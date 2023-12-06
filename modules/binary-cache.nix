{ config, hostSecretsDir, ... }:
let
  port = 47924;

in
{

  age.secrets = {
    binary-cache-key = {
      file = "${hostSecretsDir}/BinaryCache-key.age";
    };
  };

  services.nix-serve = {
    enable = true;
    # package = pkgs.nix-serve-ng;
    secretKeyFile = config.age.secrets.binary-cache-key.path;
    inherit port;
    bindAddress = "127.0.0.1";
  };

  services.caddy.virtualHosts."cache.${config.networking.fqdn}" = {
    useACMEHost = "rafael.ovh";
    extraConfig = ''
      encode zstd gzip

      header {
          Strict-Transport-Security "max-age=2592000; includeSubDomains"
      }
      reverse_proxy http://127.0.0.1:${toString port}
        
    '';
  };
}
