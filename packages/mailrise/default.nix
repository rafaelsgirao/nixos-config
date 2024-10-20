{ python3, fetchPypi }:
python3.pkgs.buildPythonPackage rec {
  pname = "mailrise";
  version = "1.4.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BKl5g4R9L5IrygMd9Vbi20iF2APpxSSfKxU25naPGTc=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    aiosmtpd
    apprise

    packaging
    setuptools # No module named 'pkg_resources'

    # Not sure if needed.
    pkginfo
    importlib-metadata

  ];
}
