use futures::Async;
use std::io::Write;
use std::io::Seek;
use futures::Poll;
use hound::WavSpec;
use futures::Sink;
use futures::AsyncSink;

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
}

impl<W: Write + Seek> WavSink<W> {
    fn blocking_io<F, T>(f: F) -> Poll<T, Error>
        where F: FnOnce() -> hound::Result<T>,
    {
        match tokio_threadpool::blocking(f) {
            Ok(Async::Ready(Ok(v))) => Ok(v.into()),
            Ok(Async::Ready(Err(err))) => Err(err.into()),
            Ok(Async::NotReady) => Ok(Async::NotReady),
            Err(_) => panic!("`blocking` annotated I/O must be called \
                   from the context of the Tokio runtime."),
        }
    }
}

impl<W: Write + Seek> WavSink<W> {
    pub fn new(writer: W, spec: WavSpec) -> Result<Self, Error> {
        Ok(Self::from_hound(hound::WavWriter::new(writer, spec)?))
    }

    pub fn from_hound(hound: hound::WavWriter<W>) -> Self {
        let spec = hound.spec();
        let bytes_per_sample = ((spec.bits_per_sample + 7) / 8) as usize;
        Self {
            hound: Some(hound),
            // 2 GB, because many programs use a signed 32-bit integer
            max_file_samples: (std::i32::MAX as usize - 1) / bytes_per_sample,
        }
    }

    pub fn poll_flush(&mut self) -> Poll<(), Error> {
        Self::blocking_io(|| self.hound().flush())
    }

    pub fn into_hound(self) -> hound::WavWriter<W> {
        self.hound.expect("WavSink has already been closed")
    }

    fn hound(&mut self) -> &mut hound::WavWriter<W> {
        self.hound.as_mut().expect("WavSink has already been closed")
    }
}

impl<W: Write + Seek> Sink for WavSink<W> {
    type SinkItem = Vec<i16>;
    type SinkError = Error;

    fn start_send(&mut self, buf: Vec<i16>) -> Result<AsyncSink<Vec<i16>>, Error> {
        let mut buf_notready = Some(buf);

        match Self::blocking_io(|| {
            let mut buf = std::mem::replace(&mut buf_notready, None).unwrap();
            let new_len = self.hound().len() as usize + buf.len();
            // Buffer that did not fit in the current file and will be returned to
            // the user through Error::FileFull
            let excess_buf = if new_len > self.max_file_samples {
                // Length that can be written to this file
                let write_len = buf.len() - (new_len - self.max_file_samples);
                Some(buf.drain(write_len..).collect::<Vec<i16>>())
            } else { None };
            for sample in buf {
                self.hound().write_sample(sample)?;
            }
            Ok(excess_buf)
        }) {
            // Return part of file that was not written so it can be written to a new file
            Ok(Async::Ready(Some(excess_buf))) => Err(Error::FileFull(excess_buf)),
            Ok(Async::Ready(None)) => Ok(AsyncSink::Ready),
            Ok(Async::NotReady) => {
                // The blocking_io block will not have executed, so this won't panic
                let buf = std::mem::replace(&mut buf_notready, None).unwrap();
                Ok(AsyncSink::NotReady(buf))
            }
            Err(e) => Err(e)
        }
    }

    fn poll_complete(&mut self) -> Poll<(), Error> {
        self.poll_flush()
    }

    fn close(&mut self) -> Poll<(), Error> {
        let hound = std::mem::replace(&mut self.hound, None)
            .expect("WavSink has already been closed");
        Self::blocking_io(|| hound.finalize())
    }
}