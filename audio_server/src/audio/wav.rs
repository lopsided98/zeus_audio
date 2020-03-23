use std::io::Seek;
use std::io::Write;
use std::pin::Pin;

use failure::Fail;
use futures::Sink;
use futures::task::{Context, Poll};
use hound::WavSpec;

// 2 GB (rounded down), because many programs use a signed 32-bit integer
const MAX_FILE_BYTES: usize = 2147483644;

#[derive(Fail, Debug)]
pub enum Error {
    #[fail(display = "File reached maximum size")]
    FileFull(Vec<i16>),
    #[fail(display = "{}", _0)]
    Hound(#[fail(cause)] hound::Error),
}

impl From<hound::Error> for Error {
    fn from(e: hound::Error) -> Self {
        Error::Hound(e)
    }
}

pub struct WavSink<W: Write + Seek> {
    hound: Option<hound::WavWriter<W>>,
    max_file_samples: usize,
    buf: Option<Vec<i16>>,
}

impl<W: Write + Seek> WavSink<W> {
    pin_utils::unsafe_unpinned!(hound: Option<hound::WavWriter<W>>);
    pin_utils::unsafe_unpinned!(buf: Option<Vec<i16>>);

    pub fn new(writer: W, spec: WavSpec) -> Result<Self, Error> {
        Ok(Self::from_hound(hound::WavWriter::new(writer, spec)?))
    }

    pub fn from_hound(hound: hound::WavWriter<W>) -> Self {
        let spec = hound.spec();
        let bytes_per_sample = ((spec.bits_per_sample + 7) / 8) as usize;
        assert_eq!(MAX_FILE_BYTES % bytes_per_sample, 0);
        let max_file_samples = MAX_FILE_BYTES / bytes_per_sample;
        assert_eq!(max_file_samples % spec.channels as usize, 0);
        Self {
            hound: Some(hound),
            max_file_samples,
            buf: None,
        }
    }

    pub fn into_hound(self) -> hound::WavWriter<W> {
        self.hound.expect("WavSink has already been closed")
    }

    fn hound_checked(self: Pin<&mut Self>) -> &mut hound::WavWriter<W> {
        self.hound().as_mut().expect("WavSink has already been closed")
    }

    fn flush(self: Pin<&mut Self>) -> Poll<Result<(), Error>> {
        Poll::Ready(tokio::task::block_in_place(|| self.hound_checked().flush())
            .map_err(|e| e.into()))
    }

    fn write_buf(mut self: Pin<&mut Self>) -> Poll<Result<(), Error>> {
        if self.buf.is_some() {
            let mut buf_pending = std::mem::replace(self.as_mut().buf(), None);

            Poll::Ready(match tokio::task::block_in_place(|| {
                let mut buf = std::mem::replace(&mut buf_pending, None).unwrap();
                let new_len = self.as_mut().hound_checked().len() as usize + buf.len();
                // Buffer that did not fit in the current file and will be returned to
                // the user through Error::FileFull
                let excess_buf = if new_len > self.max_file_samples {
                    // Length that can be written to this file
                    let write_len = buf.len() - (new_len - self.max_file_samples);
                    Some(buf.drain(write_len..).collect::<Vec<i16>>())
                } else { None };
                for sample in buf {
                    self.as_mut().hound_checked().write_sample(sample)?;
                }
                Ok(excess_buf)
            }) {
                // Return part of file that was not written so it can be written to a new file
                Ok(Some(excess_buf)) => Err(Error::FileFull(excess_buf)),
                Ok(None) => Ok(()),
                Err(e) => Err(e)
            })
        } else {
            Poll::Ready(Ok(()))
        }
    }
}

impl<W: Write + Seek> Sink<Vec<i16>> for WavSink<W> {
    type Error = Error;

    fn poll_ready(self: Pin<&mut Self>, _cx: &mut Context<'_>) -> Poll<Result<(), Error>> {
        self.write_buf()
    }

    fn start_send(mut self: Pin<&mut Self>, item: Vec<i16>) -> Result<(), Error> {
        if self.buf.is_some() {
            panic!("start_send() called when not ready");
        } else {
            *self.as_mut().buf() = Some(item);
        }
        Ok(())
    }

    fn poll_flush(mut self: Pin<&mut Self>, _cx: &mut Context<'_>) -> Poll<Result<(), Error>> {
        futures::ready!(self.as_mut().write_buf())?;
        self.flush()
    }

    fn poll_close(mut self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Result<(), Error>> {
        futures::ready!(self.as_mut().poll_flush(cx))?;

        let hound = std::mem::replace(self.hound(), None)
            .expect("WavSink has already been closed");
        Poll::Ready(tokio::task::block_in_place(|| hound.finalize())
            .map_err(|e| e.into()))
    }
}