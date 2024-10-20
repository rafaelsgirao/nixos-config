{ python3, zlib }:
python3.pkgs.buildPythonApplication rec {
  pname = "scripts";
  version = "1.0.0";
  src = ./.;
  doCheck = false;
  propagatedBuildInputs = with python3.pkgs; [
    rich

    # Not sure if needed.
    packaging
    setuptools # No module named 'pkg_resources'
    pkginfo
    importlib-metadata
  ];
}
