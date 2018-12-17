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

  cargoSha256 = "0vxxs5mc5120j8fiqwiz90832fl0w67rnm2qix4mn6kaag7anfjr";
}
