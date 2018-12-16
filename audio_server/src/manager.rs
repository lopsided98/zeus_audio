use futures::Async;
use futures::AsyncSink;
use futures::future::Future;
use futures::Poll;
use futures::sink::Sink;
use futures::sync::oneshot;

/// Future used to communicate back to a caller that an audio control request
/// has completed, possibly signalling an error.
pub struct ControlFuture<T, E> {
    rx: oneshot::Receiver<Result<T, E>>
}

impl<T, E> ControlFuture<T, E> {
    pub fn channel() -> (ControlSender<T, E>, ControlFuture<T, E>) {
        let (tx, rx) = oneshot::channel();
        (tx, ControlFuture { rx })
    }
}

impl<T, E> Future for ControlFuture<T, E> {
    type Item = T;
    type Error = E;

    fn poll(&mut self) -> Poll<T, E> {
        match self.rx.poll() {
            Ok(Async::Ready(Ok(r))) => Ok(Async::Ready(r)),
            Ok(Async::Ready(Err(e))) => Err(e),
            Ok(Async::NotReady) => Ok(Async::NotReady),
            // The audio stream should never drop a sender before completion
            Err(_) => panic!("Manager has been shutdown")
        }
    }
}

pub type ControlSender<T, E> = oneshot::Sender<Result<T, E>>;

pub trait Manager {
    type Item;
    type Error;

    fn next_future(self, item: Self::Item) -> Box<dyn Future<Item=Self, Error=Self::Error> + Send>;
}

pub struct ManagerSink<M: Manager> {
    mgr: Option<M>,
    future: Option<Box<dyn Future<Item=M, Error=M::Error> + Send>>,
}

impl<M: Manager> ManagerSink<M> {
    pub fn new(mgr: M) -> Self {
        Self {
            mgr: Some(mgr),
            future: None,
        }
    }
}

impl<M: Manager> Sink for ManagerSink<M> {
    type SinkItem = M::Item;
    type SinkError = M::Error;

    fn start_send(&mut self, item: M::Item) -> Result<AsyncSink<M::Item>, M::Error> {
        if self.future.is_none() {
            let mgr = std::mem::replace(&mut self.mgr, None).unwrap();
            self.future = Some(mgr.next_future(item));
            return Ok(AsyncSink::Ready);
        }

        match self.future.as_mut().unwrap().poll() {
            Ok(Async::Ready(mgr)) => {
                self.future = Some(mgr.next_future(item));
                Ok(AsyncSink::Ready)
            }
            Err(e) => Err(e),
            Ok(Async::NotReady) => Ok(AsyncSink::NotReady(item))
        }
    }

    fn poll_complete(&mut self) -> Poll<(), M::Error> {
        if self.future.is_some() {
            match self.future.as_mut().unwrap().poll() {
                Ok(Async::Ready(mgr)) => {
                    self.mgr = Some(mgr);
                    self.future = None;
                    Ok(Async::Ready(()))
                }
                Err(e) => Err(e),
                Ok(Async::NotReady) => Ok(Async::NotReady)
            }
        } else {
            Ok(Async::Ready(()))
        }
    }

    fn close(&mut self) -> Poll<(), M::Error> {
        self.poll_complete()
    }
}