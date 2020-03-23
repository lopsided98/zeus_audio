use std::fmt;
use std::pin::Pin;
use std::sync::Arc;
use std::sync::mpsc;
use std::sync::Mutex;
use std::sync::Weak;

use failure::Fail;
use failure::format_err;
use futures::Sink;
use futures::stream::{FusedStream, Stream};
use futures::task::{Context, Poll, Waker};

type ItemWrapper<U> = Mutex<Option<Option<U>>>;

#[derive(Fail, Debug)]
pub enum Error {
    #[fail(display = "Failed to register endpoint: {}", _0)]
    RegistrationError(#[fail(cause)] failure::Error)
}

/// Stream that copies items to an arbitrary number of endpoints. Endpoints can
/// be dynamically registered at any time. Each item can be mapped before being
/// sent to the endpoints, but is passed through unmodified to the next stream
/// in the chain. Items must be [Result]s, and their [Err] cases are not passed
/// though to the endpoints (because they normally cannot be cloned).
///
/// This stream is useful for eavesdropping on a stream and sending the results
/// to multiple clients.
#[must_use = "streams do nothing unless polled"]
pub struct TeeMap<St, F, U> {
    stream: St,
    f: F,
    // TODO: use futures::sync::mpsc
    rx: mpsc::Receiver<EndpointMessage<U>>,
    endpoints: Vec<Weak<ItemWrapper<U>>>,
}

enum EndpointMessage<U> {
    NewEndpoint(Weak<ItemWrapper<U>>),
    TaskWake(Waker),
}

/// Used to register endpoints of a [TeeMap].
#[derive(Clone)]
pub struct EndpointRegistration<U> {
    tx: mpsc::Sender<EndpointMessage<U>>
}

/// Endpoint stream for a [TeeMap].
#[derive(Debug)]
pub struct Endpoint<U> {
    item: Arc<ItemWrapper<U>>,
    tx: mpsc::Sender<EndpointMessage<U>>,
}

impl<St: Unpin, F, U> Unpin for TeeMap<St, F, U> {}

impl<St, F, U> fmt::Debug for TeeMap<St, F, U>
    where St: fmt::Debug,
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("TeeMap")
            .field("stream", &self.stream)
            .finish()
    }
}

impl<St, F, U> TeeMap<St, F, U>
{
    pin_utils::unsafe_pinned!(stream: St);
    pin_utils::unsafe_unpinned!(f: F);
    pin_utils::unsafe_unpinned!(rx: mpsc::Receiver<EndpointMessage<U>>);
    pin_utils::unsafe_unpinned!(endpoints: Vec<Weak<ItemWrapper<U>>>);

    pub fn new(stream: St, f: F) -> (Self, EndpointRegistration<U>) {
        let (tx, rx) = mpsc::channel();
        (Self { stream, f, rx, endpoints: Vec::new() }, EndpointRegistration::<U> { tx })
    }

    /// Acquires a reference to the underlying stream that this combinator is
    /// pulling from.
    pub fn get_ref(&self) -> &St {
        &self.stream
    }

    /// Acquires a mutable reference to the underlying stream that this
    /// combinator is pulling from.
    ///
    /// Note that care must be taken to avoid tampering with the state of the
    /// stream which may otherwise confuse this combinator.
    pub fn get_mut(&mut self) -> &mut St {
        &mut self.stream
    }

    /// Acquires a pinned mutable reference to the underlying stream that this
    /// combinator is pulling from.
    ///
    /// Note that care must be taken to avoid tampering with the state of the
    /// stream which may otherwise confuse this combinator.
    pub fn get_pin_mut(self: Pin<&mut Self>) -> Pin<&mut St> {
        self.stream()
    }

    /// Consumes this combinator, returning the underlying stream.
    ///
    /// Note that this may discard intermediate state of this combinator, so
    /// care should be taken to avoid losing resources when this is called.
    pub fn into_inner(self) -> St {
        self.stream
    }
}

// Forwarding impl of Sink from the underlying stream
impl<St, I, F, U> Sink<I> for TeeMap<St, F, U>
    where St: Stream + Sink<I>
{
    type Error = St::Error;

    fn poll_ready(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        self.stream().poll_ready(cx)
    }

    fn start_send(self: Pin<&mut Self>, item: I) -> Result<(), Self::Error> {
        self.stream().start_send(item)
    }

    fn poll_flush(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        self.stream().poll_flush(cx)
    }

    fn poll_close(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        self.stream().poll_close(cx)
    }
}

impl<St, T, E, F, U> FusedStream for TeeMap<St, F, U>
    where St: FusedStream + Stream<Item=Result<T, E>>,
          F: FnMut(&T) -> U,
          U: Clone
{
    fn is_terminated(&self) -> bool {
        self.stream.is_terminated()
    }
}

impl<St, T, E, F, U> Stream for TeeMap<St, F, U>
    where St: Stream<Item=Result<T, E>>,
          F: FnMut(&T) -> U,
          U: Clone
{
    type Item = St::Item;

    fn poll_next(mut self: Pin<&mut Self>, cx: &mut Context) -> Poll<Option<Self::Item>> {
        let res = futures::ready!(self.as_mut().stream().poll_next(cx));

        // Remove endpoints that have been dropped
        self.as_mut().endpoints().retain(|i| i.upgrade().is_some());

        if !self.as_mut().endpoints().is_empty() {
            // Errors are not usually Clone, so we can't send them to the
            // endpoints. Just stop the endpoints when an error is received.
            let mapped_res = match &res {
                Some(Ok(i)) => Some(self.as_mut().f()(i)),
                Some(Err(_)) => None,
                None => None
            };

            for item in self.as_mut().endpoints().iter()
                // We have to filter again because some might have been dropped
                .filter_map(Weak::upgrade) {
                (*item.lock().unwrap()) = Some(mapped_res.clone());
            }
        }

        while let Ok(msg) = self.as_mut().rx().try_recv() {
            match msg {
                EndpointMessage::NewEndpoint(item) => {
                    log::debug!("New endpoint");
                    self.as_mut().endpoints().push(item)
                }
                EndpointMessage::TaskWake(waker) =>
                    waker.wake()
            }
        }

        Poll::Ready(res)
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        self.stream.size_hint()
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

    fn poll_next(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Option<U>> {
        let item;
        {
            let mut item_lock = self.item.lock().unwrap();
            item = std::mem::replace(&mut *item_lock, None);
        }
        match item {
            None => {
                // Ask the source to wake us when there is a new message
                if self.tx.send(EndpointMessage::TaskWake(cx.waker().clone())).is_err() {
                    // Receiver disconnected, the stream must have finished and been dropped
                    Poll::Ready(None)
                } else {
                    Poll::Pending
                }
            }
            Some(i) => Poll::Ready(i)
        }
    }
}

#[cfg(test)]
mod tests {
    use futures::future::join;
    use futures::{StreamExt, TryStreamExt};

    use super::*;

    #[tokio::test]
    async fn stream_passthrough() {
        // Input data
        let vec_in = vec![1, 4, 5];

        let (tee_map, _) = TeeMap::new(
            // Wrap input data in Result
            futures::stream::iter(vec_in.clone().into_iter()
                .map::<_, fn(_) -> Result<i32, ()>>(Ok)),
            // Identity mapping
            |i: &i32| i.clone(),
        );

        assert_eq!(tee_map.map(Result::unwrap)
                       .collect::<Vec<i32>>().await, vec_in);
    }
}
