{ stdenv
, lib
, fetchurl
, alsaLib
, openssl
, zlib
, pulseaudio
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "camunda-modeler-bin";
  version = "5.17.0";

  src = fetchurl {
    # url = "https://download.studio.link/releases/v${version}-stable/linux/studio-link-standalone-v${version}.tar.gz";
    url = "https://downloads.camunda.cloud/release/camunda-modeler/${version}/camunda-modeler-${version}-linux-x64.tar.gz";
    sha256 = "sha256-yxph3Aor5nZOhu2PY4MGcfScaz9w24JXqXbhT+QKlNI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    alsaLib
    openssl
    zlib
    pulseaudio
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    cd camunda-modeler-*
    install -m755 -D camunda-modeler $out/bin/camunda-modeler
    runHook postInstall
  '';

  meta = with lib; {
    # homepage = "https://studio-link.com";
    # description = "Voip transfer";
    platforms = platforms.linux;
  };
}
