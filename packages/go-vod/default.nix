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
      rev = "385836b9d14ecb4a28802b4f9cf0ff47505772ce";
      hash = "sha256-PIqNFGdfUKEf9/YUKJJqrOmVAzLpX/q9pz6wBsVhvBs=";
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
