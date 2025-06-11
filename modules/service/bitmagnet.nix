{ lib, config, ... }:
let
  port = 42872;
  inherit (config.rg) domain;
in
{

  services.bitmagnet = {
    enable = true;
    settings = {
      # TODO: PR nixpkgs because 'port' no longer exists
      http_server.local_address = ":${toString port}";
      tmdb.enabled = false;
      processor.concurrency = 4;
      classifier.delete_xxx = true;
    };
    openFirewall = true;

  };

  systemd.services.bitmagnet.serviceConfig.DynamicUser = lib.mkForce false;

  services.caddy.virtualHosts."bitmagnet.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [ "/var/lib/bitmagnet" ];
}
