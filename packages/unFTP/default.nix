{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage rec {
  pname = "unFTP";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "bolcom";
    repo = pname;
    # rev = "v${version}";
    rev = "56d9c7f226fb7e5bbf3a8ccaa6824ecaae84f03e"; # First commit after 0.14.4 because dumb
    sha256 = "sha256-u8o5T8KvaXQGZKhd6vplrWQibjrQyBWj4a3YXGbrMZs=";
  };

  cargoSha256 = "sha256-OtsT091K68eTxTTlkoRPdmZlNU0H1Qey4TcuFcofTcM=";

  meta = with lib; {
    # description = "Simple command-line snippet manager, written in Go";
    # homepage = "https://github.com/knqyf263/pet";
    # license = licenses.mit;
    # maintainers = with maintainers; [ kalbasit ];
  };
}
