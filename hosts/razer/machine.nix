{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.networking) domain;
  # saxton's tailnet address: shp-proxy there serves Nextcloud shares publicly
  # (modules/service/shp-proxy.nix) and connects from it.
  shpProxyAddress = "100.115.32.53";
in
{

  # TODO: this should be associated with the isBuilder bool.
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "i686-linux"
  ];

  services.udisks2.enable = lib.mkDefault false;

  imports = [

    ../../modules/hardware/uefi.nix
    ../../modules/hardware/memtest86.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/zfs-unlock-initrd.nix
    ../../modules/hardware/tailscale-initrd.nix
    ../../modules/core/lanzaboote.nix

    ../../modules/acme.nix
    ../../modules/builder.nix
    ../../modules/restic.nix
    ../../modules/healthchecks.nix
    ../../modules/nextcloud.nix
    ../../modules/caddy.nix
    ../../modules/virt/libvirt.nix
    ../../modules/virt/podman.nix
    ../../modules/impermanence.nix
    ../../modules/headless.nix
    ../../modules/monero.nix

    ../../modules/service/irc.nix
    ../../modules/service/home-assistant.nix
    # ../../modules/service/ha-mcp.nix # disabled: unauthed web mode; using built-in mcp_server instead

    ../../modules/netconsole.nix
    ../../modules/bluetooth-pan.nix

    ../../modules/service/forgejo.nix
    ../../modules/service/forgejo-runner.nix
    ../../modules/service/harmonia.nix
    ../../modules/service/immich.nix
    ../../modules/service/infra-keyval.nix
    ../../modules/service/speedtest-tracker.nix
  ];

  services.openssh.openFirewall = lib.mkForce true;

  # Keeps the initrd tailscale auth key (an OAuth client secret) in place;
  # boot.initrd.secrets appends it to the initrd at bootloader install.
  age.secrets.Tailscale-initrd-authkey = {
    file = ../../secrets/razer/Tailscale-initrd-authkey.age;
    path = "/pst/etc/ssh-initrd/tailscale-authkey";
    symlink = false;
  };

  # Common group for library files
  users.groups.library = { };

  services.nextcloud.home = "/var/lib/nextcloud";

  #FIXME push these into each module
  environment.persistence."/pst".directories = [
    "/var/lib/postgresql"
    "/var/lib/nextcloud"
    "/var/data"
    "/var/music"
  ];

  # When upgrading postgres, see:
  # https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
  services.postgresql.package = pkgs.postgresql_16;

  # #TODO: add this more generically to all hosts?
  services.postgresqlBackup = {
    enable = true;
    location = "/pst/backups/postgres";
    compression = "zstd";
    backupAll = true;
  };

  rg = {
    machineId = "586da0b7ff007fbcf4e2d69e69c37e30";
    machineType = "intel";
    class = "server";
    isBuilder = true;
    resetRootFs = true;
  };

  networking.nameservers = [ "127.0.0.1" ];

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    # match the interface by name
    matchConfig.Name = "eth0";
    DHCP = "yes"; # DHCPv6 will still be triggered by RA (Router Advertisements)

    # address = [
    #   # configure addresses including subnet mask
    #   "192.168.8.60/24"
    # ];
    # routes = [ { Gateway = "192.168.8.1"; } ];
  };

  systemd.network.networks."12-usb" =
    #Ensure providing ethernet through USB works
    {
      # match the interface by name
      matchConfig.Driver = "cdc_ncm";
      DHCP = "yes";
    };

  # When the r8169 link fails to retrain the kernel detaches the NIC outright,
  # so there is no wired path left to reach the box on. wlan0 is a standby for
  # tailscale, not a general route: RouteMetric keeps eth0 preferred while it
  # lives, and RequiredForOnline=no keeps a dead AP from stalling boot.
  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    secretsFile = config.age.secrets.WiFi-psk.path;
    networks."Pingu".pskRaw = "ext:psk_home";
  };

  # nixpkgs pulls this into multi-user.target with Requires= on the device, so
  # boot waits on wlan0 if the card never enumerates. Hang it off the device
  # instead: it starts when wlan0 appears and stops when it goes.
  systemd.services.wpa_supplicant-wlan0 =
    let
      dev = "sys-subsystem-net-devices-wlan0.device";
    in
    {
      requires = lib.mkForce [ ];
      bindsTo = [ dev ];
      wantedBy = lib.mkForce [ dev ];
    };

  age.secrets.WiFi-psk.file = ../../secrets/razer/WiFi-psk.age;

  systemd.network.networks."11-wlan" = {
    matchConfig.Name = "wlan0";
    DHCP = "yes";
    dhcpV4Config.RouteMetric = 2048;
    linkConfig.RequiredForOnline = "no";
  };

  rg.netconsole = {
    enable = true;
    target = "192.168.8.231";
  };

  # Paired interactively; /var/lib/bluetooth is persisted by bluetooth.nix so
  # it survives the rootfs rollback.
  rg.bluetoothPan = {
    enable = true;
    deviceFile = config.age.secrets.BT-nap-mac.path;
  };

  age.secrets.BT-nap-mac.file = ../../secrets/razer/BT-nap-mac.age;

  networking = {
    dhcpcd.enable = false;
    firewall = {
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
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
    "cloud.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:23700
      '';
    };
  };

  # Let Nextcloud see share visitors' addresses and public host through
  # shp-proxy: Caddy keeps saxton's X-Forwarded-* instead of replacing them, and
  # Nextcloud trusts it next to Caddy. Without this, its brute-force protection
  # throttles every share visitor as one client, and share pages link to
  # cloud.${domain} instead of the public host.
  services.caddy.globalConfig = ''
    servers {
      trusted_proxies static ${shpProxyAddress}/32
    }
  '';
  services.nextcloud.settings.trusted_proxies = [ shpProxyAddress ];

}
