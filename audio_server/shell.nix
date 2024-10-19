{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  name = "audio-server-env";
  buildInputs = [
    rustc
    cargo
    rustfmt
    alsa-lib
    cmake
    pkg-config
    which
    crate2nix
  ];

  # Doesn't work in debug builds
  hardeningDisable = [ "fortify" ];

  RUST_BACKTRACE = 1;

  RUST_TOOLCHAIN = "${buildEnv {
    name = "rust-toolchain";
    paths = [ rustc cargo ];
  }}/bin";
  RUST_SRC_PATH = rustPlatform.rustcSrc;
}
