use std::path::PathBuf;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let proto_root = PathBuf::from("../protos");
    let protos: Vec<_> = [
        "audio_recorder/protos/audio_server.proto"
    ].iter().map(|p| proto_root.join(p)).collect();

    println!("cargo:rerun-if-changed={}", proto_root.display());

    if proto_root.exists() && proto_root.is_dir() {
        tonic_build::configure()
            .out_dir("src/proto")
            .build_client(false)
            .compile(&protos, &[proto_root])?;
    } else {
        println!("gRPC definitions not found, skipping compile");
    }
    Ok(())
}