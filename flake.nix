{
  description = "Software for libraries packaged for Nix by University of Borås";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        fixBundlerWarningOverlay = final: prev: {

          bundler = prev.bundler.overrideAttrs ({ postFixup ? "", ... }: {
            postFixup = postFixup + ''
              stubSpec=$(find $out -path '*bundler/stub_specification.rb')
              substituteInPlace $stubSpec \
                --replace-fail 'warn "Source #{source} is ignoring #{self} because it is missing extensions"' '# redacted because of https://github.com/NixOS/nixpkgs/issues/40024'
            '';
          });

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
        inherit (nixpkgs.lib.attrsets) genAttrs;

        # Takes a package name and generates a callPackage call to a nix-file
        # with the same name.
        #
        #     mkCallPackage "yaz"
        #     # calls `pkgs.callPackage ./pkgs/yaz.nix {}`
        mkCallPackage = (name:
          pkgs.callPackage (./. + ("/pkgs/" + name + ".nix")) {}
        );

        # The list of packages to provide. Each package should have a
        # corresponding "*.nix" file in this repo.
        packageNames = [
          "combined-log-to-json"
          "handle-client"
          "handle-server"
          "sip2-ruby"
          "yaz"
        ];

        # `genAttrs` takes a list of strings and a function and returns an
        # attribute set where the keys are the strings from the list and the
        # values are the result of the function applied to the key.
        #
        # Here we use it to generate a package attribute set by applying
        # mkCallPackage to each of our named packages.
        packages = genAttrs packageNames mkCallPackage;
      in
      {
        inherit packages;

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.ruby_3_4
            pkgs.bundix
          ];
        };

      }
    );
}
