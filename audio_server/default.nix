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

  cargoSha256 = "05r5wv1qznr0ssrv5sim27blq50mxgjfwqvvkvsn4qw9graqps2c";
}
