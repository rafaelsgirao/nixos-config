{
  python3,
  fetchPypi,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "mailrise";
  version = "1.4.0";
  # src = fetchFromGitea {
  #   domain = "git.rsg.ovh";
  #   owner = "rg";
  #   repo = "mailrise";
  #   rev = "2ec3167d88676d6b12a6285671d4c19e49ce9285";
  #   hash = "sha256-vSIlPKqR/qIGt0/DJWDNDaNwRVf1ASGJVi+baaWQEoU=";
  #   # ref = "main";
  # };
  # src = fetchGit {
  #   url = "ssh://git@git.rsg.ovh:4222/rg/mailrise.git";
  #   rev = "2ec3167d88676d6b12a6285671d4c19e49ce9285";
  #   ref = "main";
  # };
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BKl5g4R9L5IrygMd9Vbi20iF2APpxSSfKxU25naPGTc=";
  };
  doCheck = false;
  pyproject = true;
  build-system = with python3.pkgs; [ setuptools ];
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
