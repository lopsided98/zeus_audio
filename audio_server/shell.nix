{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  name = "audio-server-env";
  buildInputs = [
    rustc
    cargo
    rustfmt
    alsaLib
    cmake
    pkgconfig
    which
    nix-prefetch-git
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
