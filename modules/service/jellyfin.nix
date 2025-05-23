{ config, pkgs, ... }:
let
  inherit (config.rg) domain;
in
{
  # Common group for library files
  users.groups.library = { };

  services.caddy.virtualHosts = {
    "media.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:8096
      '';
    };

  };
  services.jellyfin.enable = true;

  environment.persistence."/state".directories = [ "/var/cache/jellyfin" ];
  environment.persistence."/pst".directories = [ "/var/lib/jellyfin" ];

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
    "library"
  ];

  environment.systemPackages = with pkgs; [
    glxinfo
    libva-utils # libva-utils --run vainfo
  ];

}
