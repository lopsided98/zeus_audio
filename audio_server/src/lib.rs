#[macro_use]
extern crate failure;
#[macro_use]
extern crate futures;
#[macro_use]
extern crate log;

mod protos;
pub mod server;
pub mod audio;
pub mod clock;
pub mod manager;