{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.rg) ip;
  inherit (config.rg) domain;
  inherit (config.networking) fqdn;
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
    # Lanzaboote fails to install for some reason. investigate when time.
    # DON'T enable just because.
    # ../../modules/core/lanzaboote.nix
    ../../modules/systemd-initrd.nix
    # ../../modules/library/jellyfin.nix
    ../../modules/polaris.nix
    ../../modules/restic.nix
    ../../modules/acme.nix
    ../../modules/attic.nix
    ../../modules/caddy.nix
    ../../modules/healthchecks.nix
    ../../modules/nextcloud.nix
    ../../modules/rss2email.nix
    ../../modules/gitea.nix
    ../../modules/impermanence.nix
    ../../modules/headless.nix
    ../../modules/blocky.nix
    # ../../modules/monero.nix
  ];

  # Common group for library files
  users.groups.library = { };

  services.nextcloud.home = "/data/nextcloud-nixos";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  hm.home.stateVersion = "21.11"; # Did you read the comment?

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
    ip = "100.104.162.12";
    ipv4 = "192.168.1.50";
    machineId = "42ef768cc806409b923c6044269f9902";
    machineType = "intel";
    class = "server";
    isBuilder = false;
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD";
  };

  environment.persistence."/pst".directories = [ "/var/lib/postgresql" ];

  networking.nameservers = [ "127.0.0.1" ];
  #Blocky - no blocklist by default
  # services.blocky.settings.blocking.clientGroupsBlock."default" = [ "none" ];
  services.blocky.settings = {
    port = "127.0.0.1:53";
    blocking.blackLists."normal" = lib.mkForce [ ]; # Foolproof way to disable blocking
    blocking.blackLists."rg" = lib.mkForce [ ]; # Foolproof way to disable blocking
  };
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
    backupCleanupCommand = "/run/current-system/sw/bin/nextcloud-occ maintenance:mode --off && ${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_SPY";
    paths = [

      #TODO: revamp this
      # decide  how to backup jellyfin (firstly, /state or /pst? then, do we backup directly (ignoring ./metadata or copy the relevant stuff to /state/backups?
      #maybe only use /state/backups if the files to backup need preprocessing (i.e, cant be backed up directly, e.g sqlite, postgres data, etc)
      "/pst"
      "${config.services.nextcloud.home}"
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

  services.uptime-kuma = {
    settings = {
      PORT = "29377";
      HOST = "127.0.0.1";
    };
    enable = true;
  };

  services.gitea = {
    stateDir = "/data/gitea-nixos";
  };

  #Hairpinning of local services.
  networking.hosts = {
    "${config.rg.ip}" = [ "cache.rafael.ovh" ];
  };

  services.caddy.globalConfig = ''
    default_bind ${config.rg.ip}
  '';
  services.caddy.virtualHosts = {
    "git.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy unix//run/gitea/gitea.sock
      '';
    };
    "kuma.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:29377
      '';
    };
    "router.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://192.168.1.254:80
      '';
    };
    "cloud.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:80
      '';
    };
    "cloud.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:80
      '';
    };
    "cache.${fqdn}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${config.rg.ip}:33763
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
