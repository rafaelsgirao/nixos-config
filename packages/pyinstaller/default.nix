{ python3
, fetchPypi
, lib
, zlib
}:
python3.pkgs.buildPythonPackage rec {
  pname = "pyinstaller";
  version = "6.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kU1MlsyZRy43rFUv3YL7vgnme7WS0HF/z/qpnqdCc98=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3.pkgs; [
    (lib.getDev zlib)
    altgraph
    packaging
    setuptools # No module named 'pkg_resources'

    # Not sure if needed.
    pkginfo
    importlib-metadata


  ];
}
