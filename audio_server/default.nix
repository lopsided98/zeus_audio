{ pkgs, callPackage, defaultCrateOverrides, pkg-config, alsaLib  }:

(import ./Cargo.nix { inherit pkgs; }).rootCrate.build.override ({
  crateOverrides ? {}, ...
}: {
  crateOverrides = crateOverrides // {
    alsa-sys = oldAttrs: {
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ alsaLib ];
    };
  };
})
