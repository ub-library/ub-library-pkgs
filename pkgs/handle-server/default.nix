{
  lib,
  stdenv,
  fetchurl,
  busybox,
  coreutils,
  jdk_headless,
  javaRuntime ? jdk_headless,
  posixTools ? (if stdenv.isDarwin then coreutils else busybox),
}:
stdenv.mkDerivation rec {
  pname = "handle-server";
  version = "9.3.2";

  src = fetchurl {
    url = "https://www.handle.net/hnr-source/handle-${version}-distribution.tar.gz";
    hash = "sha256-s9A+9EdA40wK3+9DVvEwi7eIaqumsi5+AZE42YUOsp4=";
  };

  buildInputs = [ ];

  prePatch = ''
    substituteInPlace bin/hdl \
        --replace '{HDLHOME}lib' '{HDLHOME}share/${pname}/lib'
    substituteInPlace bin/hdl --replace \
        "/bin/ls" "${posixTools}/bin/ls"
    substituteInPlace bin/hdl --replace \
        "/usr/bin/" "${posixTools}/bin/"
    substituteInPlace bin/hdl --replace \
        "exec java" "exec ${javaRuntime}/bin/java"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/$pname"

    cp -pr bin "$out/"
    cp -pr *.txt doc lib "$out/share/$pname/"

    runHook postInstall
  '';

  meta = {
    description = "Handle.Net software, including handle-server.";
    longDescription = ''
      The Handle System is a comprehensive system for assigning, managing, and
      resolving persistent identifiers for digital objects and other resources
      on the Internet. The Handle System includes an open set of protocols, an
      identifier space, and an implementation of the protocols. The protocols
      enable a distributed computer system to store identifiers of digital
      resources and resolve those identifiers into the information necessary to
      locate and access the resources. This associated information can be
      changed as needed to reflect the current state of the identified resource
      without changing the identifier, thus allowing the name of the item to
      persist over changes of location and other state information.
    '';
    homepage = "https://www.handle.net/index.html";
    license = {
      fullName = "Handle.Net Public License Agreement (ver.3)";
      url = "https://hdl.handle.net/20.1000/136";
    };
    platforms = lib.platforms.all;
  };
}
