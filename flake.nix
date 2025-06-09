{
  description = "Software for libraries packaged for Nix by University of Borås";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        fixBundlerWarning = import ./overlays/fixBundlerWarning.nix;

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fixBundlerWarning ];
        };

        combined-log-to-json = pkgs.callPackage ./pkgs/combined-log-to-json { };

        handle-client = pkgs.callPackage ./pkgs/handle-client { };

        handle-server = pkgs.callPackage ./pkgs/handle-server { };

        sip2-ruby = pkgs.callPackage ./pkgs/sip2-ruby { };

        yaz = pkgs.callPackage ./pkgs/yaz { };

      in
      {
        packages = {
          inherit
            combined-log-to-json
            handle-client
            handle-server
            sip2-ruby
            yaz
            ;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.ruby
            pkgs.bundix
          ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
