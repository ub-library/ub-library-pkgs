# Handle software packaged for nix

[Handle Client Library][hcl] and [Handle.Net Software][hns] are packages for
working with the [Handle System][handle], developed and published by [CNRI][].

[hcl]: http://www.handle.net/client_download.html
[hns]: http://www.handle.net/download_hnr.html
[handle]: https://www.rfc-editor.org/rfc/rfc3650.txt
[CNRI]: http://www.cnri.reston.va.us

This repo is just some nix expression to help installing it.

## Example using this repo in a flake

Put this in your `flake.nix`:

```nix
{
  description = "A basic flake for a shell with handle-client available";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.handle-pkgs.url = "gitlab:hb-lib-public/nix-handle-pkgs"

  outputs = { self, flake-utils, handle-pkgs }:
    flake-utils.lib.eachDefaultSystem (system: let
      hdl = handle-pkgs.packages.${system};
    in {
      devShell = pkgs.mkShell {
        buildInputs = [ hdl.handle-client ];
      };
    });
}
```

And enter the shell:
```sh
nix shell
hdl-qresolve 0.NA/0.NA
```


