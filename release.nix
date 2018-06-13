{ src ? { outPath = ./.; revCount = 1234; shortRev = "abcdef"; },
  pkgs ? import <nixpkgs> { } }: let
  jobs = {

    tarball = pkgs.stdenv.mkDerivation {
      name = "audio-recorder-tarball";
      inherit (jobs.build) version;
      
      inherit src;
      
      phases = "unpackPhase buildPhase installPhase";
      
      nativeBuildInputs = with pkgs.python3Packages; [
        pkgs.python3
        setuptools
        grpcio-tools
      ];
      buildInputs = with pkgs.python3Packages; [ 
        flask
        grpcio
        numpy
        pyyaml
        pyalsaaudio
      ];
      
      buildPhase = ''
        python setup.py sdist
      '';
      
      installPhase = ''
        mkdir -p "$out/nix-support"
        mkdir -p "$out/tarballs"
        mv "dist/"*".tar.gz" "$out/tarballs"
        for i in "$out/tarballs/"*; do
          echo "file source-dist $i" >> $out/nix-support/hydra-build-products
        done
      '';
    };

    build = pkgs.python3Packages.buildPythonPackage rec {
      pname = "audio-recorder";
      version = "0.1";
      
      src = "${jobs.tarball}/tarballs/audio_recorder-${version}.tar.gz";
      
      nativeBuildInputs = with pkgs.python3Packages; [
        grpcio-tools
      ];
      buildInputs = with pkgs.python3Packages; [ 
        flask
        grpcio
        numpy
        pyyaml
        pyalsaaudio
      ];
    };
  };
in jobs
