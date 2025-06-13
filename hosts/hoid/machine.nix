{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.rg) ip;
  inherit (config.networking) fqdn domain;
in
{
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "i686-linux"
  ];
  services.udisks2.enable = lib.mkDefault false;

  imports = [

    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/zfs-unlock-initrd.nix
    # ../../modules/core/lanzaboote.nix
    ../../modules/systemd-initrd.nix
    ../../modules/builder.nix
    # ../../modules/library/jellyfin.nix
    # ../../modules/service/polaris.nix
    ../../modules/restic.nix
    ../../modules/acme.nix
    ../../modules/attic.nix
    ../../modules/healthchecks.nix
    ../../modules/nextcloud.nix
    ../../modules/rss2email.nix
    ../../modules/caddy.nix
    ../../modules/gitea.nix
    ../../modules/virt/libvirt.nix
    ../../modules/impermanence.nix
    ../../modules/headless.nix
    ../../modules/monero.nix
    ../../modules/service/irc.nix
    ../../modules/service/jellyfin.nix
    ../../modules/service/home-assistant.nix
    ../../modules/service/bitmagnet.nix
    ../../modules/service/transmission.nix
  ];

  # Support old Nextcloud URL
  security.acme.certs."${domain}".extraDomainNames = [
    "*.rafael.ovh"
    "*.spy.rafael.ovh"
  ];

  # Common group for library files
  users.groups.library = { };

  services.nextcloud.home = "/var/lib/nextcloud";

  environment.persistence."/pst".directories = [
    "/var/lib/postgresql"
    "/var/lib/nextcloud"
    "/var/data"
    "/var/music"
  ];

  environment.persistence."/state".directories = [
    "/var/games"
  ];

  users.users.games = {
    isNormalUser = true;
    home = "/var/games";
    group = "games";
    homeMode = "770";
  };

  # Common group for games files
  users.groups.games = { };

  # When upgrading postgres, see:
  # https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
  services.postgresql.package = pkgs.postgresql_16;

  services.postgresqlBackup = {
    enable = true;
    location = "/state/backups/postgres";
    compression = "zstd";
    backupAll = true;
  };

  rg = {
    ip = "100.111.5.34";
    ipv4 = "192.168.1.50";
    machineId = "4ec1b518f0ce471f3fc4313467d368d9";
    machineType = "amd";
    class = "server";
    isBuilder = true;
    resetRootFs = true;
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMB0oR/J+r4+k5QVHrIDNqJvM4RARzGd+lQtcxhMfL5w";
  };

  networking.nameservers = [ "127.0.0.1" ];

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    # match the interface by name
    matchConfig.Name = "eth0";
    DHCP = "no"; # DHCPv6 will still be triggered by RA (Router Advertisements)

    address = [
      # configure addresses including subnet mask
      "${config.rg.ipv4}/24"
    ];
    routes = [ { Gateway = "192.168.1.1"; } ];
  };

  systemd.network.networks."12-usb" =
    #Ensure providing ethernet through USB works
    {
      # match the interface by name
      matchConfig.Driver = "cdc_ncm";
      DHCP = "yes";
    };

  networking = {
    dhcpcd.enable = false;
    firewall = {
      allowedTCPPorts = [
        6881 # Transmission
      ];
      allowedUDPPorts = [
        6881 # Transmission
      ];
    };
  };

  #Restic Backups
  services.restic.backups."${config.rg.backupsProvider}" = {
    backupPrepareCommand = "/run/current-system/sw/bin/nextcloud-occ maintenance:mode --on";
    backupCleanupCommand = "/run/current-system/sw/bin/nextcloud-occ maintenance:mode --off && ${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_HOID";
    paths = [

      "/pst"
      # "${config.services.nextcloud.home}"
      "/state/backups"
      #TODO: kuma
      #TODO: transmission, radarr, sonarr, etc.
      #TODO: remove deprecated stuff
      #TODO: storage

    ];
    extraBackupArgs = [
      "--one-file-system" # TODO: CHECK IF THIS WORKS AS INTENDED! Does it only use one filesystem per backup, or per path?
      "--exclude-caches"
      "--verbose"
    ];
  };

  # services.uptime-kuma = {
  #   settings = {
  #     PORT = "29377";
  #     HOST = "127.0.0.1";
  #   };
  #   enable = true;
  # };
  #

  #Hairpinning of local services.
  networking.hosts = {
    "127.0.0.1" = [ "cache.${domain}" ];
  };

  system.stateVersion = "24.11"; # Did you read the comment?
  hm.home.stateVersion = "24.11"; # Did you read the comment?

  services.caddy.virtualHosts = {
    "git.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy unix//run/gitea/gitea.sock
      '';
    };
    #   "kuma.${fqdn}" = {
    #     useACMEHost = "${domain}";
    #     extraConfig = ''
    #       encode zstd gzip
    #       reverse_proxy http://127.0.0.1:29377
    #     '';
    #   };
    "router.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://192.168.1.1:80
      '';
    };
    "cloud.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:23700
      '';
    };
    "cloud.spy.rafael.ovh" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:23700
      '';
    };
    "cloud.rafael.ovh" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:23700
      '';
    };
    "cache.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:33763
      '';
    };
    "polaris.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:${toString config.services.polaris.port}
      '';
    };
  };

}
