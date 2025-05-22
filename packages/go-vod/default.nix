{
  lib,
  buildGoModule,
  fetchgit,
  ...
}:
buildGoModule rec {
  pname = "go-vod";
  version = "0.2.5";

  src =
    (fetchgit {
      url = "https://github.com/pulsejet/memories.git";
      sparseCheckout = [ "go-vod" ];
      rev = "go-vod/0.2.6";
      hash = "sha256-y2kphOhkgUHQjnqsxFajU/ahByBh4669gcndpFaVYR0=";
    })
    + "/go-vod";

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
