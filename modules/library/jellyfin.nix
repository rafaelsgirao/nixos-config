{ config, pkgs, ... }:
let
  inherit (config.rg) ip;
  inherit (config.rg) domain;
  inherit (config.networking) fqdn;
in
{
  # Common group for library files
  users.groups.library = { };


  services.caddy.virtualHosts = {
    "media.${domain}" = {
      serverAliases = [ "jf.${fqdn}" ];
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${ip}:8096
      '';
    };

  };
  services.jellyfin.enable = true;


  environment.persistence."/state".directories = [
    "/var/cache/jellyfin"
  ];

  environment.persistence."/pst".directories = [
    "/var/lib/jellyfin"
  ];
  # systemd.services.jellyfin.serviceConfig = {
  # ProtectHome = true;
  # ProtectSystem = "strict";
  # ReadWritePaths = [ "/library" ];
  # ProtectProc = "noaccess";
  # ProtectClock = true;
  # ProcSubset = "pid";
  # SupplementaryGroups = [ "render" "video" "library" ];
  # DeviceAllow = [ "/dev/dri/renderD128" "/dev/dri/renderD129" "/dev/dri/card0" "/dev/dri/card1" ];
  # };

  users.users.jellyfin.extraGroups = [ "render" "video" "library" ];
  #hardware accelerated Playback
  # 1. enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  environment.systemPackages = with pkgs; [
    glxinfo
    libva-utils #libva-utils --run vainfo
  ];
  # hardware.opengl = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     # mesa.drivers
  #     intel-media-driver
  #     vaapiIntel
  #     # vaapiVdpau
  #     # libvdpau-va-gl
  #     intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
  #   ];
  # };
}
