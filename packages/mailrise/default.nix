{
  python3,
  fetchFromGitHub,
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
  src = fetchFromGitHub {

    owner = "YoRyan";
    repo = "mailrise";
    rev = "60d485e2ae22ae09ddeac25565c48e3455a8c1a7";
    hash = "sha256-CG/tYbzy1E6eQ5fW9htqLyvzc32GzlSm1UVn3nuteIg=";
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
    setuptools-scm

    # Not sure if needed.
    pkginfo
    importlib-metadata

  ];
}
