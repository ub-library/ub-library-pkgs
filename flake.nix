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
        fixBundlerWarningOverlay = final: prev: {

          bundler = prev.bundler.overrideAttrs (
            {
              postFixup ? "",
              ...
            }:
            {
              postFixup =
                postFixup
                + ''
                  stubSpec=$(find $out -path '*bundler/stub_specification.rb')
                  substituteInPlace $stubSpec \
                    --replace-fail 'warn "Source #{source} is ignoring #{self} because it is missing extensions"' '# redacted because of https://github.com/NixOS/nixpkgs/issues/40024'
                '';
            }
          );

          ruby_3_4 = prev.ruby_3_4.override {
            bundler = final.bundler;
          };

          bundlerApp = prev.bundlerApp.override {
            ruby = final.ruby_3_4;
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fixBundlerWarningOverlay ];
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
            pkgs.ruby_3_4
            pkgs.bundix
          ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
