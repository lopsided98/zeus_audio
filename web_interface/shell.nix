{ pkgs ? import <nixpkgs> { } }:

pkgs.python3Packages.callPackage ./. { dev = true; }
