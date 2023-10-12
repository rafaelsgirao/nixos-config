{ lib, buildGoModule, fetchFromGitHub, ... }:
buildGoModule rec {
  pname = "go-vod";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "pulsejet";
    repo = pname;
    rev = "${version}";
    hash = "sha256-7HT/LZp6sViVlekvONapi0iN/g0+clVc8q12ekFNDNA=";
  };

  deleteVendor = true;
  # vendorHash = "sha256-KQr0DtyH3xzlFwsDl3MGLRRLQC4+EtdTOG7IhmNCzV4=";
  vendorHash = null;

  meta = with lib; {
    # description = "Simple command-line snippet manager, written in Go";
    # homepage = "https://github.com/knqyf263/pet";
    # license = licenses.mit;
    # maintainers = with maintainers; [ kalbasit ];
  };
}
