{ python3Packages, fetchPypi, ... }:
python3Packages.buildPythonPackage rec {
  pname = "octodns";
  version = "1.2.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NyAMKJjqXVACOk2gA3pEbnbOHQbcELD2vGhad4pE5e0=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    pyyaml
    dnspython
    fqdn
    idna
    natsort
    python-dateutil
    six
    # Specify dependencies
  ];
}
