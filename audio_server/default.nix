{ pkgs, callPackage, defaultCrateOverrides, pkgconfig, alsaLib  }:

(import ./Cargo.nix { inherit pkgs; }).rootCrate.build.override ({
  crateOverrides ? {}, ...
}: {
  crateOverrides = crateOverrides // {
    alsa-sys = oldAttrs: {
      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [ alsaLib ];
    };
  };
})
