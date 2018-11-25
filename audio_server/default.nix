{ rustPlatform, grpc, protobuf, alsaLib, perl, cmake, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "audio-server-${version}";
  version = "0.3.0";

  src = { outPath = ./..; revCount = 1234; shortRev = "abcdef"; };
  sourceRoot = "AudioRecorder/audio_server";
  
  buildInputs = [
    grpc
    protobuf
    alsaLib
    perl
    cmake
    pkgconfig
  ];
  
  # Something is broken with running tests
  doCheck = false;

  cargoSha256 = "0lzw89p7904q7w0f4xciqzqh4ryvkyhiqp0i8d6hp57ypvpxagnd";
}
