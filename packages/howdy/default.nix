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
, writeText
}:
let
  pathsFile = writeText "paths.py" ''
    from pathlib import PurePath
    
    # Define the absolute path to the config directory
    config_dir = PurePath("/etc/howdy")
    
    # Define the absolute path to the DLib models data directory
    dlib_data_dir = PurePath("/etc/howdy/dlib-data")
    
    # Define the absolute path to the Howdy user models directory
    user_models_dir = PurePath("/etc/howdy/models")
    
    # Define path to any howdy logs
    log_path = PurePath("/var/log/howdy")
    
    # Define the absolute path to the Howdy data directory
    data_dir = PurePath("/etc/howdy/data")

  '';
in

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
    python3Packages.numpy
    python3Packages.opencv4
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

  #Need to force paths.py after installation,
  #Because if we pass them as meson flags,
  #howdy/meson will try writing there during nix build.
  #(Obviously, this is bad.)
  postInstall = ''
    install -Dm644 ${pathsFile} $out/lib/howdy/paths.py
  '';
  # mesonFlags = [
  #     "-Dconfig_dir=/etc/howdy"
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
