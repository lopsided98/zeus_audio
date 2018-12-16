with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "audio-server-env";
  buildInputs = [
    rustc
    cargo
    grpc
    protobuf
    alsaLib
    cmake
    pkgconfig
    which
  ];

  # Doesn't work in debug builds
  hardeningDisable = ["fortify"];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
  
  
  RUST_TOOLCHAIN = buildEnv {
    name = "rust-toolchain";
    paths = [ rustc cargo ];
  };
  RUST_SRC_PATH = rustPlatform.rustcSrc;
}

