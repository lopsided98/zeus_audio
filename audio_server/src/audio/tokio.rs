use std::io;

use futures::Async;
use futures::Poll;
use futures::Stream;
use tokio::reactor::PollEvented2;

pub struct PCM {
    poll: PollEvented2<super::mio::PCM>,
    channels: usize,
}

impl PCM {
    pub fn from_mio_pcm(pcm: super::mio::PCM) -> alsa::Result<Self> {
        let channels = pcm.get_ref().hw_params_current()?.get_channels()? as usize;
        Ok(Self {
            poll: PollEvented2::new(pcm),
            channels,
        })
    }

    pub fn poll_read(&mut self, buf: &mut [i16], status: &mut alsa::pcm::Status) -> Poll<usize, alsa::Error> {
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
        let mut res;
        loop {
            res = pcm.io_i16().unwrap().readi(buf);
            // Retry if the error could be recovered
            if res.is_ok() || pcm.try_recover(res.unwrap_err(), false).is_err() {
                break;
            }
        }

        pcm.status_in(status)?;

        match res {
            Ok(n) => {
                poll.clear_read_ready(mio::Ready::readable())
                    .map_err(|e| map_alsa_err("Failed to clear mio ready", e))?;
                Ok(Async::Ready(n * self.channels))
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
    tstamp_config: alsa::pcm::AudioTstampConfig,
    status: alsa::pcm::Status,
}

impl PCMStream {
    const BUFFER_SIZE: usize = 3000;

    pub fn new(pcm: PCM, mut tstamp_config: alsa::pcm::AudioTstampConfig) -> Self {
        let mut status = alsa::pcm::Status::new();
        status.set_audio_htstamp_config(&mut tstamp_config);
        Self {
            pcm,
            buffer: vec![0; Self::BUFFER_SIZE],
            tstamp_config,
            status,
        }
    }

    pub fn from_alsa_pcm(
        pcm: alsa::PCM,
        tstamp_config: alsa::pcm::AudioTstampConfig,
    ) -> Result<Self, alsa::Error> {
        Ok(Self::new(PCM::from_mio_pcm(super::mio::PCM::new(pcm)?)?, tstamp_config))
    }
}

impl Stream for PCMStream {
    type Item = (Vec<i16>, alsa::pcm::Status);
    type Error = alsa::Error;

    fn poll(&mut self) -> Poll<Option<(Vec<i16>, alsa::pcm::Status)>, alsa::Error> {
        match self.pcm.poll_read(&mut self.buffer, &mut self.status) {
            Ok(Async::Ready(len)) => {
                let mut buf = std::mem::replace(&mut self.buffer, vec![0; Self::BUFFER_SIZE]);
                let mut status =  alsa::pcm::Status::new();
                status.set_audio_htstamp_config(&mut self.tstamp_config);
                let status = std::mem::replace(&mut self.status, status);
                buf.truncate(len);
                Ok(Async::Ready(Some((buf, status))))
            }
            Ok(Async::NotReady) => Ok(Async::NotReady),
            Err(e) => Err(e)
        }
    }
}