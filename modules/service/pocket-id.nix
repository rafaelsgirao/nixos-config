{ config, hostSecretsDir, ... }:
let
  port = 10183;
  inherit (config.services.pocket-id) dataDir;
  inherit (config.rg) domain;

in
{
  services.pocket-id = {
    enable = true;
    environmentFile = config.age.secrets.ENV-pocket-id.path;
    settings = {
      TRUST_PROXY = true;
      APP_URL = "https://id.rafael.ovh";
      PORT = port;
    };

  };

  age.secrets.ENV-pocket-id = {
    file = "${hostSecretsDir}/ENV-pocket-id.age";
    mode = "440";
    owner = config.users.users.pocket-id.name;
    group = config.users.groups.pocket-id.name;
  };

  services.caddy.virtualHosts."id.rafael.ovh" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [
    dataDir
  ];
}
