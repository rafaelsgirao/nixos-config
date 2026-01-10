{
  # lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pythonPackages,
}:

buildHomeAssistantComponent rec {
  owner = "JurajNyiri";
  domain = "tapo_control";
  version = "7.0.12";

  src = fetchFromGitHub {
    owner = "JurajNyiri";
    repo = "HomeAssistant-Tapo-Control";
    rev = "v${version}";
    hash = "";
  };

  dependencies = with pythonPackages; [
    pytapo
  ];

}
