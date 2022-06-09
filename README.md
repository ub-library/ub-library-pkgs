# HB Lib Packages

Software packaged for nix by the [University Library][hb-library] at [University
of Borås][hb].

[hb-library]: https://www.hb.se/en/university-library/
[hb]: https://www.hb.se/en/

The packages are generally to niche to be part of nixpkgs, and are mainly useful
in a library (institution) context.

This repository contains no packages in itself but just nix expressions to
download, build and install packages from where they are originally published.
Any license for this repository does not apply to the artifacts build with it.

## Usage

Each package is defined in a separate nix-file, and combined to a package set
through `flake.nix`. To use them it is easiest to [enable nix experimental
features][flakes] `nix-command` and `flakes`.

[flakes]: https://nixos.wiki/wiki/Flakes

### Example entering a one time shell with yaz available

```sh
nix shell gitlab:hb-lib-public/hblib-pkgs#yaz
yaz-marcdump some-marcfile.mrc
```

### Example using handle-client in a flake

Put this in your `flake.nix`:

```nix
{
  description = "A basic flake for a shell with handle-client available";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.hblib-pkgs.url = "gitlab:hb-lib-public/hblib-pkgs"

  outputs = { self, flake-utils, hblib-pkgs }:
    flake-utils.lib.eachDefaultSystem (system: let
      hblib = hblib-pkgs.packages.${system};
    in {
      devShell = pkgs.mkShell {
        buildInputs = [ hblib.handle-client ];
      };
    });
}
```

And enter the shell:
```sh
nix shell
hdl-qresolve 0.NA/0.NA
```

## Packages

### handle-client and handle-server

[Handle Client Library][hcl] and [Handle.Net Software][hns] are packages for
working with the [Handle System][handle], developed and published by [CNRI][].

[hcl]: http://www.handle.net/client_download.html
[hns]: http://www.handle.net/download_hnr.html
[handle]: https://www.rfc-editor.org/rfc/rfc3650.txt
[CNRI]: http://www.cnri.reston.va.us

This repo is just some nix expression to help installing it.

### yaz

[YAZ][] is a programmers’ toolkit supporting the development of Z39.50/SRW/SRU
clients and servers. It is published by [Index Data][indexdata] under an revised
BSD license. Among other things it includes `yaz-marcdump` that can be used to
convert between MARC formats and a line based serialization format of MARC that
is very convenient to work with on the command line.

[YAZ]: https://www.indexdata.com/resources/software/yaz/
[indexdata]: https://www.indexdata.com
