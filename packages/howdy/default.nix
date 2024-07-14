{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libevdev
, inih
, python3
, python3Packages
, cmake
, pam
}:

stdenv.mkDerivation rec {
  pname = "howdy";
  version = "0.0.1"; #Fake!

  src = fetchFromGitHub {
    owner = "boltgolt";
    repo = "howdy";
    rev = "aa75c7666c040c6a7c83cd92b9b81a6fea4ce97c";
    hash = "sha256-oYw2xoqLdERy51fYk6zLUZ5Agkr6OKFcvUnFgvHH5rU=";
  };

  dontUseCmakeConfigure = true;

  buildInputs = [
    inih
    libevdev
    pam
  ];
  nativeBuildInputs = [
    cmake
    meson
    python3
    ninja
    pkg-config
    python3Packages.wheel
    python3Packages.setuptools
  ];

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
