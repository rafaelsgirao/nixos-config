{ python3Packages, fetchPypi, octodns, ... }:

python3Packages.buildPythonPackage rec {
  pname = "octodns-cloudflare";
  version = "0.0.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E+5wD8QWgg2R0VnHDekj8snXozC2dgClqGULECy6UUg=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    pyyaml
    certifi
    charset-normalizer
    dnspython
    fqdn
    idna
    natsort
    octodns
    requests
    python-dateutil
    six
    urllib3
    # Specify dependencies
  ];
}
