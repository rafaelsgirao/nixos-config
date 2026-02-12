{
  # lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pytapo,
  ffmpeg,
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

  dependencies = [
    pytapo
  ];
  buildInputs = [ ffmpeg ];
  nativeBuildInputs = [ ffmpeg ];
  propagatedBuildInputs = [ ffmpeg ];

}
