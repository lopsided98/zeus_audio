use std::pin::Pin;

use futures::future::Future;
use futures::sink::Sink;
use futures::task::{Context, Poll};

pub trait Manager: Sized {
    type Item;
    type Error;

    fn next_future(self, item: Self::Item) -> Pin<Box<dyn Future<Output=Result<Self, Self::Error>> + Send>>;
}

pub struct ManagerSink<M: Manager> {
    mgr: Option<M>,
    future: Option<Pin<Box<dyn Future<Output=Result<M, M::Error>> + Send>>>,
}

impl<M: Manager> ManagerSink<M> {
    pin_utils::unsafe_unpinned!(mgr: Option<M>);
    pin_utils::unsafe_unpinned!(future: Option<Pin<Box<dyn Future<Output=Result<M, M::Error>> + Send>>>);

    pub fn new(mgr: M) -> Self {
        Self {
            mgr: Some(mgr),
            future: None,
        }
    }
}

impl<M: Manager> Sink<M::Item> for ManagerSink<M> {
    type Error = M::Error;

    fn poll_ready(mut self: Pin<&mut Self>, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        match self.as_mut().future() {
            None => Poll::Ready(Ok(())),
            Some(future) => {
                match future.as_mut().poll(cx) {
                    Poll::Ready(Ok(mgr)) => {
                        *self.as_mut().mgr() = Some(mgr);
                        *self.as_mut().future() = None;
                        Poll::Ready(Ok(()))
                    }
                    Poll::Ready(Err(e)) => Poll::Ready(Err(e)),
                    Poll::Pending => Poll::Pending
                }
            }
        }
    }

    fn start_send(mut self: Pin<&mut Self>, item: M::Item) -> Result<(), Self::Error> {
        let mgr = std::mem::replace(self.as_mut().mgr(), None)
            .expect("start_send() called when not ready");
        *self.as_mut().future() = Some(mgr.next_future(item));
        Ok(())
    }

    fn poll_flush(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        self.poll_ready(cx)
    }

    fn poll_close(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Result<(), Self::Error>> {
        self.poll_ready(cx)
    }
}