extern crate alsa;
extern crate core;
extern crate crossbeam;
extern crate futures;
extern crate grpcio;
extern crate hound;
extern crate libc;
#[macro_use]
extern crate log;
extern crate protobuf;
extern crate regex;

mod protos;
pub mod server;
pub mod audio;
pub mod clock;