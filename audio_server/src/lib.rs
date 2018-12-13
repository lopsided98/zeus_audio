extern crate alsa;
extern crate core;
#[macro_use]
extern crate failure;
extern crate failure_derive;
#[macro_use]
extern crate futures;
extern crate grpcio;
extern crate hound;
extern crate libc;
#[macro_use]
extern crate log;
extern crate mio;
extern crate nix;
extern crate protobuf;
extern crate regex;
extern crate tokio;
extern crate tokio_threadpool;

mod protos;
pub mod server;
pub mod audio;
pub mod clock;