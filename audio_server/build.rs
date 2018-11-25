extern crate protoc_grpcio;

use std::path::PathBuf;

fn main() {
    let proto_root = PathBuf::from("../protos/audio_recorder/protos");
    println!("cargo:rerun-if-changed={}", proto_root.to_string_lossy());
    if proto_root.exists() && proto_root.is_dir() {
        protoc_grpcio::compile_grpc_protos(
            &["audio_server.proto"],
            &[proto_root],
            "src/protos",
        ).expect("Failed to compile gRPC definitions!");
    } else {
        println!("gRPC definitions not found, skipping compile");
    }
}