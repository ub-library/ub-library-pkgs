{lib, stdenv, fetchurl, jre, coreutils}:

stdenv.mkDerivation rec {
  pname = "handle-client";
  version = "9.3.0";

  src = fetchurl {
    url = "https://www.handle.net/hnr-source/${pname}-${version}-distribution.tar.gz";
    sha256 = "sha256-uBABcysRfUMd9VW8ZBEKOI35mWEkyOWLoUah3hDJt3g=";
  };

  buildInputs = [];

  prePatch = ''
    substituteInPlace bin/hdl \
        --replace '{HDLHOME}lib' '{HDLHOME}share/${pname}/lib'
    substituteInPlace bin/hdl --replace \
        "/bin/ls" "${coreutils}/bin/ls"
    substituteInPlace bin/hdl --replace \
        "/usr/bin/" "${coreutils}/bin/"
    substituteInPlace bin/hdl --replace \
        "exec java" "exec ${jre}/bin/java"
    ''; 

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/$pname"

    cp -pr bin "$out/"
    cp -pr *.txt doc lib "$out/share/$pname/"

    runHook postInstall
    '';

  meta = {
    description = "Java libraries and scripts for using the handle protocol.";
    longDescription = ''
      The Java™ Version of the Client Library is a library of Java classes which
      understands the handle protocol and would form the foundation for
      Java-based custom client software development.
    '';
    homepage = https://www.handle.net/index.html;
    license =  {
      fullName = "CNRI License Agreement for Client Library (ver. 9.3.0) — Java™ Version";
      url = http://hdl.handle.net/20.1000/114;
    };
    platforms = lib.platforms.all;
  };
}
