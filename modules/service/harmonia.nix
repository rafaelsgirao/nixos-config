{
  config,
  secretsDir,
  ...
}:
let
  inherit (config.networking) domain;
  port = 33763;
in
{
  age.secrets = {
    harmonia-server = {
      file = "${secretsDir}/harmonia-server.age";
    };
  };
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ config.age.secrets.harmonia-server.path ];
    settings = {
      bind = "127.0.0.1:${toString port}";
      priority = 10;
    };

  };
  services.caddy.virtualHosts = {
    "cache.rsg.ovh" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };
}
