{ 
dbus,
lib, 
pkg-config,
stdenv,
systemdLibs,
fetchFromGitHub,
... }:
stdenv.mkDerivation rec {
  pname = "zypak";
  version = "2022.04";

  src = fetchFromGitHub {
    owner = "refi64";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gg7IAmIYiRhdAK/luqhDtQhqj7fWk6OWqTwItoX9/JI=";
  };


  nativeBuildInputs = [
      dbus
      pkg-config
      systemdLibs

  ];
  meta = with lib; {
    # description = "Simple command-line snippet manager, written in Go";
    # homepage = "https://github.com/knqyf263/pet";
    # license = licenses.mit;
    # maintainers = with maintainers; [ kalbasit ];
  };
}
