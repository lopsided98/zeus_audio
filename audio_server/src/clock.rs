use std::io;
use std::process::Command;
use std::sync::Arc;
use std::sync::atomic::AtomicBool;
use std::sync::atomic::Ordering;

use futures::Future;
use futures::future::Either;
use futures::future::IntoFuture;
use tokio_process::CommandExt;

#[derive(Debug, Fail)]
pub enum Error {
    #[fail(display = "Command cannot be executed because device is the clock master")]
    Master,
    #[fail(display = "Command cannot be executed because device is not the clock master")]
    NotMaster,
    #[fail(display = "System time was already set, ignoring request")]
    TimeAlreadySet,
    #[fail(display = "Failed to set time: {}", _0)]
    SetTimeFailed(#[fail(cause)] failure::Error),
    #[fail(display = "Failed to start clock sync: {}", _0)]
    StartSyncFailed(#[fail(cause)] failure::Error),
}

#[derive(Clone)]
pub struct Clock {
    master: bool,
    time_set: Arc<AtomicBool>,
}

impl Clock {
    pub fn new(master: bool) -> Clock {
        Clock {
            master,
            time_set: Arc::new(AtomicBool::new(false)),
        }
    }

    fn chronyc_command() -> Command {
        let mut c = Command::new("sudo");
        c.arg("-n").arg("-u").arg("chrony").arg("chronyc");
        c
    }

    pub fn set_time(&mut self, seconds: i64, nanos: i32) -> Result<(), Error> {
        if !self.master {
            Err(Error::NotMaster)
        } else if self.time_set.load(Ordering::Relaxed) {
            Err(Error::TimeAlreadySet)
        } else {
            let time = libc::timespec {
                tv_sec: seconds as libc::time_t,
                tv_nsec: nanos as libc::c_long,
            };
            let r = unsafe { libc::clock_settime(libc::CLOCK_REALTIME, &time) };
            if r < 0 {
                Err(Error::SetTimeFailed(io::Error::last_os_error().into()))
            } else {
                self.time_set.store(true, Ordering::Relaxed);
                Ok(())
            }
        }
    }

    pub fn start_sync(&self) -> impl Future<Item=(), Error=Error> {
        if self.master {
            Either::A(Err(Error::Master).into_future())
        } else {
            Either::B(Command::new("systemctl")
                .arg("is-active")
                .arg("--quiet")
                .arg("chronyd")
                .status_async().map_err(|e| Error::StartSyncFailed(e.into()))
                .into_future()
                .and_then(|s| s.map_err(|e| Error::StartSyncFailed(e.into()))
                    .and_then(|status| if status.success() {
                        Err(Error::TimeAlreadySet)
                    } else {
                        Ok(())
                    }))
                .and_then(|_| Command::new("sudo")
                    .arg("-n") // Non-interactive mode
                    .arg("systemctl")
                    .arg("start")
                    .arg("chronyd")
                    .output_async().map_err(|e| Error::StartSyncFailed(e.into()))
                    .and_then(|output| if output.status.success() {
                        Ok(())
                    } else {
                        let stderr = std::str::from_utf8(&output.stderr)
                            .map_err(|e| Error::StartSyncFailed(e.into()))?;
                        Err(Error::StartSyncFailed(format_err!("Failed to start chronyd: {}", stderr)))
                    }))
                .and_then(|_| Self::chronyc_command()
                    .arg("-m")
                    .arg("burst 10/15")
                    .arg("waitsync 30 0 0 0.5")
                    .output_async().map_err(|e| Error::StartSyncFailed(e.into())))
                .and_then(|output| if output.status.success() {
                    Ok(())
                } else {
                    let stdout = std::str::from_utf8(&output.stdout)
                        .map_err(|e| Error::StartSyncFailed(e.into()))?;
                    Err(Error::StartSyncFailed(format_err!("Failed to synchronize clock: {}", stdout)))
                }))
        }
    }
}