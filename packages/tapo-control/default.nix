{
  # lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  python3Packages,
}:

buildHomeAssistantComponent rec {
  owner = "JurajNyiri";
  domain = "tapo_control";
  version = "7.0.12";

  src = fetchFromGitHub {
    owner = "JurajNyiri";
    repo = "HomeAssistant-Tapo-Control";
    rev = "${version}";
    hash = "sha256-iZyF320bZ44lOz+A6MxoWfSmMqmTBsMDs/CGnngxySI=";
  };

  dependencies = with python3Packages; [
    pytapo
  ];

}
