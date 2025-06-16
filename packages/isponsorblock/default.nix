{ python3, fetchFromGitHub }:
python3.pkgs.buildPythonPackage rec {
  pname = "isponsorblocktv";
  version = "v2.5.2";
  src = fetchFromGitHub {
    owner = "dmunozv04";
    repo = "iSponsorBlockTV";
    rev = version;
    hash = "sha256-i59pJ9w5L1nPD4QyhLtFP6Qv2hszrT7uKp5849kupQE=";

  };
  pyproject = true;

  doCheck = false;
  build-system = with python3.pkgs; [
    hatchling
    hatch-requirements-txt
  ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    appdirs

    async-cache
    pyytlounge
    rich
    ssdp
    textual
    textual-slider
    xmltodict
    rich-click

    packaging
    setuptools # No module named 'pkg_resources'

    # Not sure if needed.
    pkginfo
    importlib-metadata

  ];
}
