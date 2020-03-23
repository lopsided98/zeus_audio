use std::io;
use std::pin::Pin;

use futures::Stream;
use futures::task::{Context, Poll};
use tokio::io::PollEvented;

use crate::audio::timestamp::AudioTimestamp;

/// Enables asynchronous reading from an ALSA PCM device. See [PCMStream] for a
/// wrapper that provides a stream of sample buffers.
pub struct PCM {
    poll: PollEvented<super::mio::PCM>,
    channels: usize,
    period: u64,
}

impl PCM {
    pub fn from_mio_pcm(pcm: super::mio::PCM) -> alsa::Result<Self> {
        let channels;
        let period;
        {
            let hw_params = &pcm.get_ref().hw_params_current()?;
            channels = hw_params.get_channels()? as usize;
            period = 1_000_000_000 / hw_params.get_rate()? as u64;
        }
        let poll_pcm = PollEvented::new(pcm)
            .map_err(|e| Self::convert_io_error("Failed to create PollEvented", e))?;

        Ok(Self {
            poll: poll_pcm,
            channels,
            period,
        })
    }

    fn read_timestamp(&self, pcm: &alsa::PCM, buf: &mut [i16]) -> Result<(usize, AudioTimestamp), alsa::Error> {
        let now = AudioTimestamp::now();
        let mut delay = pcm.delay()?;
        pcm.io_i16().unwrap().readi(buf).map(|n| {
            // This shouldn't happen, but prevent an overflow if it does
            if delay < 0 {
                delay = 0;
            }
            let timestamp = &now - self.period * delay as u64;
            (n, timestamp)
        })
    }

    /// Read timestamped samples into the specified buffer.
    pub fn poll_read(&self, cx: &mut Context, buf: &mut [i16]) -> Poll<Result<(usize, AudioTimestamp), alsa::Error>> {
        let poll = &self.poll;
        futures::ready!(poll.poll_read_ready(cx, mio::Ready::readable()))
            .map_err(|e| Self::convert_io_error("Failed to poll ALSA", e))?;

        let pcm = poll.get_ref().get_ref();

        let res = loop {
            let res = self.read_timestamp(pcm, buf);
            if let Err(e) = res {
                match pcm.state() {
                    alsa::pcm::State::XRun => log::warn!("ALSA buffer overrun"),
                    _ => ()
                };
                // Retry if the error could be recovered
                if pcm.try_recover(e, false).is_err() {
                    log::debug!("Failed to recover ALSA error");
                    break res;
                }
            } else {
                break res;
            }
        };

        match res {
            Ok((n, timestamp)) => {
                poll.clear_read_ready(cx, mio::Ready::readable())
                    .map_err(|e| Self::convert_io_error("Failed to clear mio ready", e))?;
                Poll::Ready(Ok((n * self.channels, timestamp)))
            }
            Err(e) => {
                let errno = e.errno().unwrap();
                if errno == nix::errno::Errno::EAGAIN {
                    poll.clear_read_ready(cx, mio::Ready::readable())
                        .map_err(|e| Self::convert_io_error("Failed to clear mio ready", e))?;
                    Poll::Pending
                } else { Poll::Ready(Err(e)) }
            }
        }
    }

    fn convert_io_error(msg: &'static str, e: io::Error) -> alsa::Error {
        match e.raw_os_error() {
            Some(e) => alsa::Error::new(msg, e),
            // I don't think this will ever happen, but return some kind of error anyway
            None => alsa::Error::unsupported(msg)
        }
    }
}

/// Stream of timestamped ALSA PCM sample buffers.
pub struct PCMStream {
    pcm: PCM
}

impl PCMStream {
    const BUFFER_SIZE: usize = 3000;

    pub fn new(pcm: PCM) -> Self {
        Self { pcm }
    }

    pub fn from_alsa_pcm(pcm: alsa::PCM) -> Result<Self, alsa::Error> {
        Ok(Self::new(PCM::from_mio_pcm(super::mio::PCM::new(pcm)?)?))
    }
}

impl Stream for PCMStream {
    type Item = Result<(Vec<i16>, AudioTimestamp), alsa::Error>;

    fn poll_next(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Option<Self::Item>> {
        let mut buffer = vec![0; Self::BUFFER_SIZE];
        match self.pcm.poll_read(cx, &mut buffer) {
            Poll::Ready(Ok((len, timestamp))) => {
                buffer.truncate(len);
                Poll::Ready(Some(Ok((buffer, timestamp))))
            }
            Poll::Ready(Err(e)) => Poll::Ready(Some(Err(e))),
            Poll::Pending => Poll::Pending
        }
    }
}