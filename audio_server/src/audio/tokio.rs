use std::io;

use futures::Async;
use futures::Poll;
use futures::Stream;
use tokio::reactor::PollEvented2;
use crate::audio::timestamp::AudioTimestamp;

pub struct PCM {
    poll: PollEvented2<super::mio::PCM>,
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
        Ok(Self {
            poll: PollEvented2::new(pcm),
            channels,
            period,
        })
    }

    pub fn poll_read(&mut self, buf: &mut [i16]) -> Poll<(usize, AudioTimestamp), alsa::Error> {
        fn map_alsa_err(msg: &'static str, e: io::Error) -> alsa::Error {
            match e.raw_os_error() {
                Some(e) => alsa::Error::new(msg, e),
                // I don't think this will ever happen, but return some kind of error anyway
                None => alsa::Error::unsupported(msg)
            }
        }

        let poll = &mut self.poll;
        try_ready!(poll.poll_read_ready(mio::Ready::readable())
            .map_err(|e| map_alsa_err("Failed to poll ALSA", e)));

        let pcm = poll.get_ref().get_ref();

        let timestamp;

        let res = {
            let mut now;
            let mut delay;

            let mut res;
            loop {
                now = AudioTimestamp::now();
                res = {
                    delay = pcm.delay()?;
                    pcm.io_i16().unwrap().readi(buf)
                };
                if let Err(e) = res {
                    match pcm.state() {
                        alsa::pcm::State::XRun => warn!("ALSA buffer overrun"),
                        _ => ()
                    };
                    // Retry if the error could be recovered
                    if pcm.try_recover(e, false).is_err() {
                        break;
                    }
                } else {
                    break;
                }
            }

            // This shouldn't happen, but prevent an overflow if it does
            if delay < 0 {
                delay = 0;
            }
            timestamp = &now - self.period * delay as u64;

            res
        };

        match res {
            Ok(n) => {
                poll.clear_read_ready(mio::Ready::readable())
                    .map_err(|e| map_alsa_err("Failed to clear mio ready", e))?;
                Ok(Async::Ready((n * self.channels, timestamp)))
            }
            Err(e) => {
                let errno = e.errno().unwrap();
                if errno == nix::errno::Errno::EAGAIN {
                    poll.clear_read_ready(mio::Ready::readable())
                        .map_err(|e| map_alsa_err("Failed to clear mio ready", e))?;
                    Ok(Async::NotReady)
                } else { Err(e) }
            }
        }
    }
}

pub struct PCMStream {
    pcm: PCM,
    buffer: Vec<i16>,
}

impl PCMStream {
    const BUFFER_SIZE: usize = 3000;

    pub fn new(pcm: PCM) -> Self {
        Self {
            pcm,
            buffer: vec![0; Self::BUFFER_SIZE],
        }
    }

    pub fn from_alsa_pcm(pcm: alsa::PCM) -> Result<Self, alsa::Error> {
        Ok(Self::new(PCM::from_mio_pcm(super::mio::PCM::new(pcm)?)?))
    }
}

impl Stream for PCMStream {
    type Item = (Vec<i16>, AudioTimestamp);
    type Error = alsa::Error;

    fn poll(&mut self) -> Poll<Option<(Vec<i16>, AudioTimestamp)>, alsa::Error> {
        match self.pcm.poll_read(&mut self.buffer) {
            Ok(Async::Ready((len, timestamp))) => {
                let mut buf = std::mem::replace(&mut self.buffer, vec![0; Self::BUFFER_SIZE]);
                buf.truncate(len);
                Ok(Async::Ready(Some((buf, timestamp))))
            }
            Ok(Async::NotReady) => Ok(Async::NotReady),
            Err(e) => Err(e)
        }
    }
}