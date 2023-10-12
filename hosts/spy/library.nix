{ config, pkgs, inputs, hostSecretsDir, ... }:
let
  ip = config.rg.ip;
  domain = config.rg.domain;
  fqdn = config.networking.fqdn;
  dotnetHardening = {
    CapabilityBoundingSet = [ "" ];
    SystemCallArchitectures = "native";
    SystemCallFilter =
      [ "~@reboot @privileged @obsolete @raw-io @mount @debug @cpu-emulation" ];
    PrivateDevices = true;
    PrivateIPC = true;
    ProtectProc = "invisible";
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectHostname = true;
    ProtectClock = true;
    # RestrictAddressFamilies = [ "AF_INET AF_INET6 AF_UNIX" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    # PrivateUsers = true;
    ProtectControlGroups = true;
    ProcSubset = "pid";
    LockPersonality = true;
    # MemoryDenyWriteExecute = true; # Prowlarr (Dotnet?) requires not using this
    #Otherwise it fails with a message, regarding CoreCLR
    ProtectHome = true;
    NoNewPrivileges = true;
  };
  moreHardening = {
    PrivateTmp = true;
    ProtectSystem = "strict";
    ReadWritePaths = [ "/library" ];
    RestrictSUIDSGID = true;
  };
  transmission-url = "transmission.${fqdn}";
in
{
  # Common group for library files
  users.groups.library = { };

  # Only prowlarr runs as a DynamicUser, so need to persist
  # environment.persistence."/data/nix".directories = [ "/var/lib/prowlarr" ];

  # Radarr
  services.radarr = {
    enable = true;
    group = "library";
    dataDir = "/data/torrents-nix/radarr";
  };
  systemd.services.radarr.serviceConfig = dotnetHardening // moreHardening // {
    ReadWritePaths = [ "${config.services.radarr.dataDir} /library" ];
  };

  services.sonarr = {
    enable = true;
    dataDir = "/data/torrents-nix/sonarr";
    group = "library";
  };
  systemd.services.sonarr.serviceConfig = dotnetHardening // moreHardening // {
    ReadWritePaths = [ "${config.services.sonarr.dataDir} /library" ];
  };

  # systemd.services.sonarr.serviceConfig = dotnetHardening // moreHardening // { ReadWritePaths = [ config.services.sonarr.dataDir ]; };

  # Prowlarr
  services.prowlarr.enable = true;
  # # WARNING: Don't put moreHardening in prowlarr (already has it b/c it's a DynamicUser service
  # systemd.services.prowlarr.serviceConfig = dotnetHardening // { };
  # environment.persistence."/persist".directories = [ "/var/lib/prowlarr" ];

  age.secrets.Transmission-creds = {
    file = "${hostSecretsDir}/Transmission-creds.age";
    owner = "transmission";
  };

  #Transmission
  services.transmission = {
    enable = true;
    performanceNetParameters = true;
    openPeerPorts = true;
    home = "/data/transmission";
    group = "library";
    downloadDirPermissions = "770";
    #Defines:
    # - announce-ip
    # - rpc-password
    # - peer-port
    credentialsFile = config.age.secrets.Transmission-creds.path;
    settings = {
      # default-trackers = builtins.readFile (inputs.trackerslist + "/trackers_best.txt");
      announce-ip-enabled = true;
      incomplete-dir = "/library/downloads/.incomplete";
      download-dir = "/library/downloads";
      rpc-host-whitelist = transmission-url;
      rpc-username = "rg";
      rpc-authentication-required = true;

    };
  };

  # systemd.services.flood = {
  #   description = "Flood Torrent UI";
  #   after = [ "network.target" "transmission.service" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig =
  #     let
  #       extraArgs = [
  #         "--trurl https://${config.services.transmission.}"
  #         "--rundir /var/lib/flood"
  #         "--truser rg"
  #         "--trpass $TRANSMISSION_PASS"
  #       ];
  #     in dotnetHardening // {
  #       Type = "simple";
  #       environmentFile = config.age.secrets.Transmission-creds.path;


  #       ExecStart =
  #         "${pkgs.flood}/bin/flood"
  #            ++ concatStringsSep "" [extraArgs]  
  #       DynamicUser = true;
  #       StateDirectory = "flood";
  #       ReadWritePaths = [ "/library/downloads" ];
  #       PrivateTmp = true;
  #       ProtectSystem = "strict";
  #       RestrictSUIDSGID = true;
  #       # RestrictAddressFamilies = [ "AF_NETLINK" ];
  #       MemoryDenyWriteExecute = true;
  #       RemoveIPC = true;
  #   };
  # };


  services.caddy.virtualHosts = {
    "media.${domain}" = {
      serverAliases = [ "jf.${fqdn}" ];
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${ip}:8096
      '';
    };
    "transmission.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:9091
      '';
    };

    "radarr.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:7878
      '';
    };
    "prowlarr.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${ip}:9696
      '';
    };
    "sonarr.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:8989
      '';
    };

  };
  #TODO: persistence /var/lib/jellyfin
  services.jellyfin.enable = true;
  systemd.services.jellyfin.serviceConfig = {
    ProtectHome = true;
    ProtectSystem = "strict";
    ReadWritePaths = [ "/library" ];
    ProtectProc = "noaccess";
    ProtectClock = true;
    ProcSubset = "pid";
    SupplementaryGroups = [ "render" "video" "library" ];
    DeviceAllow = [ "/dev/dri/renderD128" "/dev/dri/card0" ];
  };

  #hardware accelerated Playback
  # 1. enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };
}
