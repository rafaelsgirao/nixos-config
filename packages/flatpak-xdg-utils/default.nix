{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, glib
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatpak-xdg-utils";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "flatpak-xdg-utils";
    rev = version;
    sha256 = "sha256-TqUV8QpBti+86FElCdHXifIS2dsShA/POFUyZwjTHOE=";
  };

  # sourceRoot = "${src.name}/src";

  # postPatch = ''
  #   patchShebangs install_links.py
  # '';
  dontUseCmakeConfigure = true;

  mesonFlags = [
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];
  buildInputs = [
    (lib.getDev glib)
  ];
  nativeBuildInputs = [
    # glib
    # glib.dev
    cmake
    meson
    # python3
    ninja
    pkg-config
  ];

  # outputs = [ "bin" "dev" "out" "man" ];

  # mesonFlags = [
  #   "-Ddocs=disabled"
  # ];

  strictDeps = true;

  # passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    # description = "High-quality data compression program";
    # license = licenses.bsdOriginal;
    # pkgConfigModules = [ "bz2" ];
    # platforms = platforms.all;
    # maintainers = [];
  };
}
