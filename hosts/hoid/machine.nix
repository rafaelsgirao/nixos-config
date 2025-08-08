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

  nix.settings = {
    max-jobs = 8;
    cores = 6;
  };

  # TODO: this should be associated with the isBuilder bool.
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
    ../../modules/builder.nix
    ../../modules/restic.nix
    ../../modules/acme.nix
    ../../modules/attic.nix
    ../../modules/healthchecks.nix
    ../../modules/nextcloud.nix
    ../../modules/caddy.nix
    ../../modules/gitea.nix
    ../../modules/virt/libvirt.nix
    ../../modules/impermanence.nix
    ../../modules/headless.nix
    ../../modules/monero.nix

    ../../modules/service/irc.nix
    ../../modules/service/jellyfin.nix
    ../../modules/service/home-assistant.nix
    ../../modules/service/transmission.nix
    ../../modules/service/actual.nix
    ../../modules/service/forgejo.nix
  ];

  # Servers need rest too! Maybe.
  systemd.services.go-to-bed =
    let
      #
      sleepTime = 6 * 3600;
    in
    {
      serviceConfig.Type = "oneshot";
      path = [ pkgs.util-linux ];
      script = ''
        #!/bin/sh
        rtcwake -u -s ${toString sleepTime} -m mem
      '';
    };

  systemd.timers.go-to-bed-2200 = {
    wantedBy = [ "timers.target" ];
    partOf = [ "go-to-bed.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 19:59:59";
      Unit = "go-to-bed.service";
    };
  };

  services.openssh.openFirewall = lib.mkForce true;

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

  # When upgrading postgres, see:
  # https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
  services.postgresql.package = pkgs.postgresql_16;

  #TODO: add this more generically to all hosts?
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
      "/state/backups"
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
        reverse_proxy unix//run/forgejo/forgejo.sock
      '';
    };
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
  };

}
