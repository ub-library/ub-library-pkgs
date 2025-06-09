{ bundlerApp, lib }:
bundlerApp {
  pname = "sip2-ruby";
  gemdir = ./.;
  exes = [
    "sip2-to-json"
    "json-to-sip2"
  ];

  meta = {
    description = "Convert Sip2 messages to JSON and back";
    longDescription = ''
      Scripts for parsing and encoding SIP2 messages (a standard
      for data exchange between Library Automation Systems and Library Systems).
    '';
    homepage = "https://github.com/ub-library/sip2-ruby";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
