# Latest Nightly
let
  src = (import <nixpkgs> {}).fetchFromGitHub {
      owner = "mozilla";
      repo = "nixpkgs-mozilla";
      # commit from: 2018-10-30
      rev = "0d64cf67dfac2ec74b2951a4ba0141bc3e5513e8";
      sha256 = "0ngj2rk898rq73rq2rkwjax9p34mjlh3arj8w9npwwd6ljncarmh";
   };
in
with import <nixpkgs> {
  overlays = [
    (import "${src}/rust-overlay.nix")
    (import "${src}/rust-src-overlay.nix")
  ];
};
stdenv.mkDerivation {
  name = "audio-server-env";
  buildInputs = [
    latest.rustChannels.stable.rust
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
}

