{ rustPlatform, grpc, protobuf, alsaLib, perl, cmake, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "audio-server-${version}";
  version = "0.3.0";

  src = { outPath = ./.; revCount = 1234; shortRev = "abcdef"; };
  
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

  cargoSha256 = "0hn9593y7b3n0cavnhmar8jq2y8nsplm86yg2r5njrawsy5k57gh";
}
