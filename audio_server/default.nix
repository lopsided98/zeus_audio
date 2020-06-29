{ callPackage, defaultCrateOverrides, pkgconfig, alsaLib  }:

((callPackage ./Cargo.nix {
  cratesIO = callPackage ./crates-io.nix {};
}).audio_server {}).override (old: {
  crateOverrides = defaultCrateOverrides // {
    alsa-sys = oldAttrs: {
      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [ alsaLib ];
    };
  };
})
