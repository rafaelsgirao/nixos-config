{ config, ... }:
let
  inherit (config.networking) domain;
  port = 53545;
in
{
  services.actual = {
    enable = true;

    settings = {
      hostname = "127.0.0.1";
      trustedProxies = [ "127.0.0.1" ];
    };
  };

  systemd.services.actual.serviceConfig = {
    DynamicUser = false;
    User = "actual";
    Group = "actual";
  };
  services.caddy.virtualHosts."actual.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [
    {
      directory = "/var/lib/actual";
      user = "actual";
      group = "actual";
      mode = "700";
    }
  ];

  users.groups.actual = { };

  users.users = {
    actual = {
      group = "actual";
      # extraGroups = [ "caddy" ];
      isSystemUser = true;
    };
  };

}
