{
  stdenv,
  jdk,
  ant,
  fetchsvn,
  ...
}:
stdenv.mkDerivation rec {
  pname = "drawj2d";
  version = "1.3.3";

  src =
    (fetchsvn {
      url = "https://svn.code.sf.net/p/drawj2d/code/";
      # sparseCheckout = [
      #   "go-vod"
      # ];
      rev = "r362";
      hash = "sha256-qDdjmWNAB2x9xrr+RIvURz/esWd9CUw/jIRVrmGqMV0=";
    })
    + "/tags/${pname}-${version}";

  nativeBuildInputs = [
    jdk
    ant
  ];

  installPhase = ''
    mkdir $out
    cp -R dist/. $out/

    mkdir $out/bin
    mv $out/drawj2d $out/bin/
  '';

  buildPhase = "ant";
}
