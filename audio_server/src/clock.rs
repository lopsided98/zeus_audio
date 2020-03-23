use std::io;
use std::sync::Arc;
use std::sync::atomic::AtomicBool;
use std::sync::atomic::Ordering;

use failure::Fail;
use tokio::process::Command;
use futures::Future;

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

    /// Command to start chronyc with sudo. Extra arguments can be appended
    /// before running.
    fn chronyc_command() -> Command {
        let mut c = Command::new("sudo");
        c.arg("-n").arg("-u").arg("chrony").arg("chronyc");
        c
    }

    /// Manually set the time to the specified value, relative to the Unix
    /// epoch. This can only be called on the master, and can only be done
    /// once.
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

    /// Start NTP time synchronization. This starts the chronyd systemd service
    /// and sends a burst synchronization command. This can only be run on
    /// other than the master, and it can only be run once.
    pub fn start_sync(&self) -> impl Future<Output=Result<(), Error>> {
        let master = self.master;
        let time_set = self.time_set.clone();
        async move {
            if master {
                return Err(Error::Master);
            }
            if time_set.load(Ordering::Relaxed) {
                return Err(Error::TimeAlreadySet);
            }

            let systemctl_output = Command::new("sudo")
                .arg("-n") // Non-interactive mode
                .arg("systemctl")
                .arg("start")
                .arg("chronyd")
                .output().await
                .map_err(|e| Error::StartSyncFailed(e.into()))?;

            if !systemctl_output.status.success() {
                let stderr = std::str::from_utf8(&systemctl_output.stderr)
                    .map_err(|e| Error::StartSyncFailed(e.into()))?;
                return Err(Error::StartSyncFailed(failure::format_err!("Failed to start chronyd: {}", stderr)));
            }


            let chronyc_output = Self::chronyc_command()
                .arg("-m")
                .arg("burst 10/15")
                .arg("waitsync 30 0 0 0.5")
                .output().await
                .map_err(|e| Error::StartSyncFailed(e.into()))?;

            if !chronyc_output.status.success() {
                let stdout = std::str::from_utf8(&chronyc_output.stdout)
                    .map_err(|e| Error::StartSyncFailed(e.into()))?;
                return Err(Error::StartSyncFailed(failure::format_err!("Failed to synchronize clock: {}", stdout)));
            }

            time_set.store(true, Ordering::Relaxed);
            Ok(())
        }
    }
}