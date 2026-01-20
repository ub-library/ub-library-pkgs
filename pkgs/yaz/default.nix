{
  stdenv,
  lib,
  fetchurl,
  libiconv,
  icu,
  libxslt,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "yaz";
  version = "5.37.0";

  src = fetchurl {
    url = "http://ftp.indexdata.com/pub/yaz/${pname}-${version}.tar.gz";
    hash = "sha256-klf+sG4v27/Ot9BAwTn6E5V8TR67pqopOm3RPKsiJc4=";
  };

  buildInputs = [
    icu
    libiconv
    libxml2
    libxslt
    pkg-config
  ];

  meta = {
    description = "A C/C++ library for using the Z39.50/SRU/Solr protocols.";
    longDescription = ''
      YAZ is a C/C++ library for applications using the Z39.50/SRU/Solr
      protocols for information retrieval.
    '';
    homepage = "https://www.indexdata.com/resources/software/yaz/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
