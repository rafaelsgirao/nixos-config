{ config, hostSecretsDir, ... }:
let
  port = toString 47924;

in
{

  age.secrets = {
    binary-cache-key = {
      file = "${hostSecretsDir}/BinaryCache-key.age";
    };
  };

  services.harmonia = {
    enable = true;
    signKeyPath = config.age.secrets.binary-cache-key.path;
    settings.bind = "127.0.0.1:${port}";
  };

  services.caddy.virtualHosts."cache.${config.networking.fqdn}" = {
    useACMEHost = "rafael.ovh";
    extraConfig = ''
      encode zstd gzip

      header {
          Strict-Transport-Security "max-age=2592000; includeSubDomains"
      }
      reverse_proxy http://127.0.0.1:${port}
        
    '';
  };

  nix.settings.secret-key-files = config.age.secrets.binary-cache-key.path;
}
