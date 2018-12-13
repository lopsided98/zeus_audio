use std::io;
use std::os::unix::io::RawFd;

use alsa::poll::PollDescriptors;
use mio::Evented;
use mio::Poll;
use mio::PollOpt;
use mio::Ready;
use mio::Token;
use mio::unix::EventedFd;

pub struct PCM {
    pcm: alsa::PCM,
    poll_fds: Vec<RawFd>,
}

impl PCM {
    pub fn new(pcm: alsa::PCM) -> Result<Self, alsa::Error> {
        let poll_fds = pcm.get()
            .map(|fds| fds.iter().map(|f| f.fd).collect())?;
        Ok(PCM { pcm, poll_fds })
    }

    pub fn start(&self) -> alsa::Result<()> {
        self.pcm.start()
    }

    pub fn pause(&self, pause: bool) -> alsa::Result<()> {
        self.pcm.pause(pause)
    }

    pub fn io_i16(&self) -> alsa::Result<alsa::pcm::IO<i16>> {
        self.pcm.io_i16()
    }

    pub fn get_ref(&self) -> &alsa::PCM {
        &self.pcm
    }

    pub fn get_ref_mut(&mut self) -> &mut alsa::PCM {
        &mut self.pcm
    }

    fn poll_fds(&self) -> &[RawFd] {
        &self.poll_fds
    }
}

impl Evented for PCM {
    fn register(&self, poll: &Poll, token: Token, interest: Ready, opts: PollOpt) -> Result<(), io::Error> {
        for fd in self.poll_fds() {
            EventedFd(&fd).register(poll, token, interest, opts)?;
        }
        Ok(())
    }

    fn reregister(&self, poll: &Poll, token: Token, interest: Ready, opts: PollOpt) -> Result<(), io::Error> {
        for fd in self.poll_fds() {
            EventedFd(&fd).reregister(poll, token, interest, opts)?;
        }
        Ok(())
    }

    fn deregister(&self, poll: &Poll) -> Result<(), io::Error> {
        for fd in self.poll_fds() {
            EventedFd(&fd).deregister(poll)?;
        }
        Ok(())
    }
}

//unsafe impl Send for PCM {}
