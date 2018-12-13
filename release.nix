{ src ? { outPath = ./.; revCount = 1234; shortRev = "abcdef"; },
  pkgs ? import <nixpkgs> { } }:
let
  version = "0.3.0";
  jobs = {
    audio-server = rec {
      tarball = pkgs.stdenv.mkDerivation {
        name = "audio_server-tarball-${version}";
        inherit version;
        
        src = "${src}/audio_server";
        
        dontBuild = true;
        
        installPhase = ''
          mkdir -p "$out/nix-support"
          mkdir -p "$out/tarballs"
          tar -czf "$out/tarballs/audio_server-${version}.tar.gz" \
            --exclude=target \
            --exclude=.idea \
            --transform 's,^\.,audio_server,' .
          for i in "$out/tarballs/"*; do
            echo "file source-dist $i" >> $out/nix-support/hydra-build-products
          done
        '';
      };
      build = (pkgs.callPackage ./audio_server {}).overrideDerivation (old: {
        src = "${tarball}/tarballs/audio_server-${version}.tar.gz";
      });
    };
  
    web-interface = rec {
      tarball = pkgs.stdenv.mkDerivation {
        name = "audio_recorder-tarball-${version}";
        inherit version;
        
        src = "${src}/web_interface";
        
        nativeBuildInputs = with pkgs.python3Packages; [
          python
          setuptools
          grpcio-tools
          grpcio
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
      build = (pkgs.python3Packages.callPackage ./web_interface {}).overrideDerivation (old: {
        src = "${tarball}/tarballs/audio_recorder-${version}.tar.gz";
      });
    };
  };
in jobs
