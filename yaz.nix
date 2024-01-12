{stdenv, lib, fetchurl, libiconv, icu, libxslt, libxml2, pkg-config}:

stdenv.mkDerivation rec {
  name = "yaz-5.31.0";

  src = fetchurl {
    url = "http://ftp.indexdata.com/pub/yaz/${name}.tar.gz";
    sha256 = "058dzskanmhmrgfl0c5fyy4bv4b3p4p4wg9bg0rc32jps5v48kc6";
  };

  buildInputs = [ icu libiconv libxml2 libxslt pkg-config ];

  meta = {
    description = "A C/C++ library for using the Z39.50/SRU/Solr protocols.";
    longDescription = ''
      YAZ is a C/C++ library for applications using the Z39.50/SRU/Solr
      protocols for information retrieval.
    '';
    homepage = https://www.indexdata.com/resources/software/yaz/;
    license =  lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
