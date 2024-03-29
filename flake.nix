{
  description = "Software for libraries packaged for Nix by University of Borås";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
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
      { inherit packages; }
    );
}
