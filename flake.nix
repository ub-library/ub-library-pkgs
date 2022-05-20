{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        handle-client = pkgs.callPackage ./handle-client.nix {};
      in {
        packages.handle-client = handle-client;
        packages.default = handle-client;

        devShell = pkgs.callPackage ./shell.nix {};
      }
    );
}
