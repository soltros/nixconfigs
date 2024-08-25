with (import <nixpkgs> {}) ;
mkShell {
  buildInputs = [
    bison
    flex
    fontforge
    makeWrapper
    pkg-config
    gnumake
    gcc
    libiconv
    autoconf
    automake
    libtool # freetype calls glibtoolize
  ];
}
