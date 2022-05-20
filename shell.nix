{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell {
  buildInputs = [ (callPackage ./handle-client.nix {}) ];
}
