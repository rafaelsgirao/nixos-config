{ config, hostSecretsDir, ... }:
let
  inherit (config.rg) ip;
  inherit (config.rg) domain;
  inherit (config.networking) fqdn;
  dotnetHardening = {
    CapabilityBoundingSet = [ "" ];
    SystemCallArchitectures = "native";
    SystemCallFilter =
      # [ "~@reboot  @obsolete @raw-io @mount @debug @cpu-emulation" ];
      [ "@system-service" ];
    SystemcallErrorNumber = "EPERM";
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

  # Radarr
  services.radarr = {
    enable = true;
    group = "library";
    dataDir = "/data/torrents-nix/radarr";
  };
  systemd.services.radarr.serviceConfig =
    dotnetHardening
    // moreHardening
    // {
      ReadWritePaths = [ "${config.services.radarr.dataDir} /library" ];
    };

  services.sonarr = {
    enable = true;
    dataDir = "/data/torrents-nix/sonarr";
    group = "library";
  };
  systemd.services.sonarr.serviceConfig =
    dotnetHardening
    // moreHardening
    // {
      ReadWritePaths = [ "${config.services.sonarr.dataDir} /library" ];
    };

  # systemd.services.sonarr.serviceConfig = dotnetHardening // moreHardening // { ReadWritePaths = [ config.services.sonarr.dataDir ]; };

  # Prowlarr
  services.prowlarr.enable = true;

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
      ratio-limit = 12.0;
      ratio-limit-enabled = true;
      idle-seeding-limit = 10080;
      idle-seeding-limit-enabled = true;
      message-level = 1; # Log only error messages. Default is 2, spams the hell out of journal

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
    "flood.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:39629
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

  environment.persistence."/pst".directories = [
    # "/var/lib/private/prowlarr"
  ];
}
