{ lib, buildGoModule, fetchFromGitHub, ... }:
buildGoModule rec {
  pname = "go-vod";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "pulsejet";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-OTi1ouMLHOrCIg1HL6I7tLz/p6y5uE8GQxL3jFSuKB0=";
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
