{
  python3,
  fetchFromGitHub,
  lib,
  zlib,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pre-commit-macadmin";
  version = "1.14.1";
  src = fetchFromGitHub {
    owner = "homebysix";
    repo = "pre-commit-macadmin";
    rev = "v${version}";
    hash = "sha256-jj0G8NC6xueVl3pfAu9/Xv0Vkp37Y83y8ncpG7CHkUo=";
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
