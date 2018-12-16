use std::ops;
use std::fmt;
use std::ops::Deref;
use std::ops::DerefMut;
use std::time::Duration;
use std::time::SystemTime;

use libc::timespec;

#[derive(Debug, Clone)]
pub struct AudioTimestamp(pub u64);

impl AudioTimestamp {

    pub fn now() -> Self {
        SystemTime::now().into()
    }
}

impl ops::Sub for &AudioTimestamp {
    type Output = AudioTimestamp;

    fn sub(self, rhs: Self) -> AudioTimestamp {
        (**self - **rhs).into()
    }
}

impl ops::Sub<&u64> for &AudioTimestamp {
    type Output = AudioTimestamp;

    fn sub(self, rhs: &u64) -> AudioTimestamp {
        (**self - rhs).into()
    }
}

impl Deref for AudioTimestamp {
    type Target = u64;

    fn deref(&self) -> &u64 {
        &self.0
    }
}

impl DerefMut for AudioTimestamp {
    fn deref_mut(&mut self) -> &mut u64 {
        &mut self.0
    }
}

impl From<u64> for AudioTimestamp {
    fn from(nanos: u64) -> Self {
        AudioTimestamp(nanos)
    }
}

impl From<libc::timespec> for AudioTimestamp {
    fn from(t: timespec) -> Self {
        AudioTimestamp((t.tv_sec * 1_000_000_000 + t.tv_nsec) as u64)
    }
}

impl From<SystemTime> for AudioTimestamp {
    fn from(t: SystemTime) -> Self {
        let since_epoch = t.duration_since(std::time::UNIX_EPOCH)
            // If we get a timestamp before the epoch, something is very wrong
            // and we should probably crash
            .expect("Timestamp earlier than epoch");
        AudioTimestamp((since_epoch.as_secs() * 1_000_000_000 + since_epoch.subsec_nanos() as u64) as u64)
    }
}

impl Into<SystemTime> for AudioTimestamp {
    fn into(self) -> SystemTime {
        std::time::UNIX_EPOCH + Duration::from_nanos(self.0)
    }
}

impl fmt::Display for AudioTimestamp {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        fmt::Display::fmt(&**self ,f)
    }
}