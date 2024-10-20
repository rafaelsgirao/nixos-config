{ config, hostSecretsDir, ... }:

let
  stateDir = "/var/lib/ist-discord-bot";
in
{

  age.secrets.ENV-ist-discord-bot = {
    file = "${hostSecretsDir}/ENV-ist-discord-bot.age";
    mode = "400";
    owner = "ist-discord-bot";
  };

  environment.persistence."/pst".directories = [
    {
      directory = stateDir;
      user = "ist-discord-bot";
      group = "ist-discord-bot";
      mode = "700";
    }
  ];

  virtualisation.oci-containers.containers.ist-discord-bot = {
    image = "ist-discord-bot:2";
    hostname = "oci-ist-discord-bot";
    volumes = [ "/var/lib/ist-discord-bot/data:/app/data" ];
    environmentFiles = [ config.age.secrets.ENV-ist-discord-bot.path ];
    environment = {
      DATABASE_URL = "file:/app/data/bot.db";
      TZ = "Europe/Lisbon";
    };
  };

}
