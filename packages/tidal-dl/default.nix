{
  lib,
  python3,
  fetchPypi,
  lyricsgenius,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tidal-dl";
  version = "2022.10.31.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b2AAsiI3n2/v6HC37fMI/d8UcxZxsWM+fnWvdajHrOg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
    colorama
    prettytable
    mutagen
    psutil
    pycryptodome
    aigpy
    lyricsgenius
    pydub
    lyricsgenius

    # tornado
    # python-daemon
  ];

  meta = with lib; { };
}
