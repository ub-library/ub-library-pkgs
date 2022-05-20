{
  description = "Handle Client Library and Handle.Net Software packaged for nix";

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
        packages.default = handle-client;
        packages.handle-client = handle-client;
        packages.handle-server = pkgs.callPackage ./handle-server.nix {};

        devShell = pkgs.callPackage ./shell.nix {};
      }
    );
}
