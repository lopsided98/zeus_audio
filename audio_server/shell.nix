with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "audio-server-env";
  buildInputs = [
    rustc
    cargo
    rustPlatform.rustcSrc
    grpc
    protobuf
    alsaLib
    cmake
    pkgconfig
    which
    #rust-bindgen
  ];

  # Doesn't work in debug builds
  hardeningDisable = ["fortify"];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}

