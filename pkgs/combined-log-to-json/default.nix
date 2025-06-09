{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "combined-log-to-json";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "ub-library";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T294Ls6/NYHwepGcfXK5KMLgWbwBQQ4WGTZvxc5t4T4=";
  };
  vendorHash = null;

  meta = {
    description = "A simple script to convert the combined log format to json";
    longDescription = ''
      A simple script to convert web server logs from the combined log format
      (NCSA Common log format extended with referer and user-agent) into JSON.

      Primarily useful to enable filtering and inspection of logs using `jq`
      or a similar tool, instead of operating on the plain text data with e.g.
      `grep` or `awk`.

      The combined log format is commonly used by e.g. Apache HTTP Server and
      EZproxy.
    '';
    homepage = "https://github.com/ub-library/combined-log-to-json";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
