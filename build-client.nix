{ pkgs ? import <nixpkgs> {} }:
with pkgs;
callPackage ./handle-client.nix {}
