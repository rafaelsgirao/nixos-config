{ python3, fetchPypi, ... }:
python3.pkgs.buildPythonPackage rec {
  pname = "lyricsgenius";
  version = "3.0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g671X/yguOppZRxLFEaT0cASaHp9pX+I0JWzM/LhiSg=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    requests
  ];
}
