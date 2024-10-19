{ pkgs, callPackage, defaultCrateOverrides, pkg-config, alsa-lib }:

(import ./Cargo.nix { inherit pkgs; }).rootCrate.build.override ({
  crateOverrides ? {}, ...
}: {
  crateOverrides = crateOverrides // {
    alsa-sys = oldAttrs: {
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ alsa-lib ];
    };
  };
})
