{ callPackage, defaultCrateOverrides, grpc, protobuf, alsaLib, perl, cmake, pkgconfig }:

((callPackage ./Cargo.nix {
  cratesIO = callPackage ./crates-io.nix {};
}).audio_server {}).override (old: {
  crateOverrides = defaultCrateOverrides // {
    alsa-sys = oldAttrs: {
      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [ alsaLib ];
    };
    grpcio-sys = oldAttrs: {
      nativeBuildInputs = [ perl cmake ];
      buildInputs = [ grpc ];
    };
  };
})
