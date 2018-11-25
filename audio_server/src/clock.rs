use std::io;

pub fn set_time(seconds: u64, nanos: u32) -> Result<(), io::Error> {
    let time = libc::timespec {
        tv_sec: seconds as libc::time_t,
        tv_nsec: nanos as libc::c_long,
    };
    let r = unsafe { libc::clock_settime(libc::CLOCK_REALTIME, &time) };
    if r < 0 {
        Err(io::Error::last_os_error())
    } else {
        Ok(())
    }
}