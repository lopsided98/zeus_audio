{
  description = "Synchronized distributed audio recording";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crate2nix = { url = "github:kolloch/crate2nix"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, crate2nix }:
    with flake-utils.lib;
    eachSystem allSystems (system: let
      crate2nixOverlay = final: prev: {
        crate2nix = import crate2nix { pkgs = final; };
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay crate2nixOverlay ];
      };
    in {
      packages = {
        inherit (pkgs.audio-recorder) audio-server web-interface;
      };

      devShell = import ./audio_server/shell.nix { inherit pkgs; };
    }) //
    eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: {
      hydraJobs = {
        inherit (self.packages.${system}) audio-server web-interface;
      };
    }) //
    {
      overlay = final: prev: {
        audio-recorder = {
          audio-server = final.callPackage ./audio_server { };
          web-interface = final.python3Packages.callPackage ./web_interface { };
        };
      };

      nixosModule = import ./module.nix { inherit (self) overlay; };
    };
}
