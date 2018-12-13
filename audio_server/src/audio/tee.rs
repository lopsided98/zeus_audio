use std::sync::Arc;
use std::sync::mpsc;
use std::sync::Mutex;
use std::sync::Weak;

use futures::Async;
use futures::Poll;
use futures::Sink;
use futures::StartSend;
use futures::Stream;
use futures::task;
use futures::task::Task;

type ItemWrapper<U> = Mutex<Option<Result<Option<U>, ()>>>;

#[derive(Fail, Debug)]
pub enum Error {
    #[fail(display = "Failed to register endpoint: {}", _0)]
    RegistrationError(#[fail(cause)] failure::Error)
}

pub struct TeeMap<S: Stream, F, U> {
    stream: S,
    f: F,
    // TODO: use futures::sync::mpsc
    rx: mpsc::Receiver<EndpointMessage<U>>,
    endpoints: Vec<Weak<ItemWrapper<U>>>,
}

enum EndpointMessage<U> {
    NewEndpoint(Weak<ItemWrapper<U>>),
    TaskNotify(Task),
}

#[derive(Clone)]
pub struct EndpointRegistration<U> {
    tx: mpsc::Sender<EndpointMessage<U>>
}

#[derive(Debug)]
pub struct Endpoint<U> {
    item: Arc<ItemWrapper<U>>,
    tx: mpsc::Sender<EndpointMessage<U>>,
}


impl<S: Stream, F, U> TeeMap<S, F, U>
    where F: FnMut(&S::Item) -> U
{
    pub fn new(stream: S, f: F) -> (Self, EndpointRegistration<U>) {
        let (tx, rx) = mpsc::channel();
        (Self { stream, f, rx, endpoints: Vec::new() },
         EndpointRegistration::<U> { tx })
    }

    /// Acquires a reference to the underlying stream that this combinator is
    /// pulling from.
    pub fn get_ref(&self) -> &S {
        &self.stream
    }

    /// Acquires a mutable reference to the underlying stream that this
    /// combinator is pulling from.
    ///
    /// Note that care must be taken to avoid tampering with the state of the
    /// stream which may otherwise confuse this combinator.
    pub fn get_mut(&mut self) -> &mut S {
        &mut self.stream
    }

    /// Consumes this combinator, returning the underlying stream.
    ///
    /// Note that this may discard intermediate state of this combinator, so
    /// care should be taken to avoid losing resources when this is called.
    pub fn into_inner(self) -> S {
        self.stream
    }
}

// Forwarding impl of Sink from the underlying stream
impl<S: Sink + Stream, F, U> Sink for TeeMap<S, F, U> {
    type SinkItem = S::SinkItem;
    type SinkError = S::SinkError;

    fn start_send(&mut self, item: Self::SinkItem) -> StartSend<Self::SinkItem, Self::SinkError> {
        self.stream.start_send(item)
    }

    fn poll_complete(&mut self) -> Poll<(), Self::SinkError> {
        self.stream.poll_complete()
    }

    fn close(&mut self) -> Poll<(), Self::SinkError> {
        self.stream.close()
    }
}

impl<S, F, U> Stream for TeeMap<S, F, U>
    where S: Stream,
          F: FnMut(&S::Item) -> U,
          U: Clone
{
    type Item = S::Item;
    type Error = S::Error;

    fn poll(&mut self) -> Poll<Option<Self::Item>, Self::Error> {
        let res = match self.stream.poll() {
            Ok(Async::Ready(t)) => Ok(t),
            Ok(Async::NotReady) => return Ok(Async::NotReady),
            Err(e) => Err(e),
        };

        // Remove endpoints that have been dropped
        self.endpoints.retain(|i| i.upgrade().is_some());

        if !self.endpoints.is_empty() {
            // Errors are not usually Copy, so we can't send them to the
            // endpoints. Just stop the endpoints when an error is received.
            let mapped_res: Result<Option<U>, ()> = match &res {
                Ok(Some(i)) => Ok(Some((self.f)(i))),
                Ok(None) => Ok(None),
                Err(_) => Ok(None)
            };

            for item in self.endpoints.iter()
                // We have to filter again because some might have been dropped
                .filter_map(Weak::upgrade) {
                (*item.lock().unwrap()) = Some(mapped_res.clone());
            }
        }

        while let Ok(msg) = self.rx.try_recv() {
            match msg {
                EndpointMessage::NewEndpoint(item) => {
                    debug!("New endpoint");
                    self.endpoints.push(item)
                }
                EndpointMessage::TaskNotify(task) =>
                    task.notify()
            }
        }

        match res {
            Ok(t) => Ok(Async::Ready(t)),
            Err(e) => Err(e)
        }
    }
}

impl<U> EndpointRegistration<U> {
    pub fn add_endpoint(&self) -> Result<Endpoint<U>, Error> {
        let item = Arc::new(Mutex::new(None));
        self.tx.send(EndpointMessage::NewEndpoint(Arc::downgrade(&item)))
            .map_err(|e| Error::RegistrationError(format_err!("{}", e)))?;
        Ok(Endpoint { item, tx: self.tx.clone() })
    }
}


impl<U> Stream for Endpoint<U> {
    type Item = U;
    type Error = ();

    fn poll(&mut self) -> Poll<Option<U>, ()> {
        let item;
        {
            let mut item_lock = self.item.lock().unwrap();
            item = std::mem::replace(&mut *item_lock, None);
        }
        match item {
            None => {
                if self.tx.send(EndpointMessage::TaskNotify(task::current())).is_err() {
                    // Receiver disconnected, the stream must have finished and been dropped
                    Ok(Async::Ready(None))
                } else {
                    Ok(Async::NotReady)
                }
            }
            Some(Ok(i)) => Ok(Async::Ready(i)),
            Some(Err(e)) => Err(e)
        }
    }
}