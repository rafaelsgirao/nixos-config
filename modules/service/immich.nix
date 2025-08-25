{ config, ... }:
let
  inherit (config.networking) domain;
  baseDir = config.services.immich.mediaLocation;
  port = 56689;
in
{

  services.caddy.virtualHosts."immich.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy localhost:${builtins.toString port}
    '';
  };

  # https://wiki.nixos.org/wiki/Immich#Enabling_Hardware_Accelerated_Video_Transcoding
  services.immich = {
    enable = true;
    inherit port;
    accelerationDevices = null; # null will give access to all devices.
    redis.enable = true;

  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  environment.persistence."/pst".directories = [ "${baseDir}" ];
}
