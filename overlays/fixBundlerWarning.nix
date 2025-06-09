final: prev: {
  bundler = prev.bundler.overrideAttrs (
    {
      postFixup ? "",
      ...
    }:
    {
      postFixup =
        postFixup
        + ''
          stubSpec=$(find $out -path '*bundler/stub_specification.rb')
          substituteInPlace $stubSpec \
            --replace-fail 'warn "Source #{source} is ignoring #{self} because it is missing extensions"' '# redacted because of https://github.com/NixOS/nixpkgs/issues/40024'
        '';
    }
  );

  ruby = prev.ruby.override {
    bundler = final.bundler;
  };

  bundlerApp = prev.bundlerApp.override {
    ruby = final.ruby;
  };
}
