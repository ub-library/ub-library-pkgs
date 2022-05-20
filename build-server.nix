{ pkgs ? import <nixpkgs> {} }:
with pkgs;
callPackage ./handle-server.nix {}
