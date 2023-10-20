{ config, pkgs, lib, profiles, hostSecretsDir, ... }:
let
  hostname = config.networking.hostName;
  inherit (config.rg) ip;
  inherit (config.networking) fqdn;
in
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  services.udisks2.enable = lib.mkDefault false;
  imports = with profiles; [
    ./library.nix
    acme.nix
    caddy.nix
    healthchecks.nix
    nextcloud.nix
    rss2email.nix
    gitea.nix
    monero.nix
    lanzaboote.nix
    nvidia.nix
    headless.nix
    zfs.nix
    zfs-unlock.nix
    blocky.nix
    uefi.nix
    wakapi-server.nix
  ];

  services.nextcloud.home = "/data-spy/nextcloud-nixos";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  age.secrets = {
    rclone-config = {
      file = "${hostSecretsDir}/../rclone-config.age";
    };
    restic-env = {
      file = "${hostSecretsDir}/../restic-env.age";
    };
    restic-password = {
      file = "${hostSecretsDir}/../restic-password.age";
    };
  };

  services.postgresqlBackup = {
    enable = true;
    location = "/state-heavy/backups/postgres";
    compression = "zstd";
    backupAll = true;
  };

  rg = {
    ip = "192.168.10.6";
    machineType = "intel";
    class = "server";
  };
  #Blocky - no blocklist by default
  # services.blocky.settings.blocking.clientGroupsBlock."default" = [ "none" ];
  services.blocky.settings = {
    blocking.blackLists."normal" =
      lib.mkForce [ ]; # Foolproof way to disable blocking

    blocking.clientGroupsBlock = { "127.0.0.1" = [ "none" ]; };
  };
  networking = {
    hostId = "b18b039a";
    dhcpcd.enable = false;
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.1.80";
      prefixLength = 24;
    }];
    firewall = {
      allowedTCPPorts = [
        6881 # Transmission
      ];
      allowedUDPPorts = [
        6881 # Transmission
      ];
    };
  };
  #Allow fly.io and VPS gateways to access Spy's ports
  services.nebula.networks."rgnet".firewall.inbound = [{
    port = "5050-5060";
    proto = "any";
    groups = [ "gateway" ];
  }];


  #Remote ZFS pool unlock
  boot.kernelParams =
    [ "ip=192.168.1.80::192.168.1.1:255.255.255.0::eth0:none" ];

  boot.initrd.network.postCommands = ''
    cat << EOF > /root/.profile
    if pgrep -x "zfs" > /dev/null
    then
      zpool import neonheavypool
      zfs load-key -a
      killall zfs
    else
      echo "zfs not running -- maybe the pool is taking some time to load for some unforseen reason."
    fi
    EOF
  '';


  #Restic Backups
  services.restic.backups."spy-oneDriveIST" = {
    user = "root";
    repository = "rclone:oneDriveIST:/Restic-Backups";
    timerConfig = { OnCalendar = "*-*-* 4:30:00"; };
    rcloneConfigFile = config.age.secrets.rclone-config.path;
    environmentFile = config.age.secrets.restic-env.path;
    passwordFile = config.age.secrets.restic-password.path;
    backupPrepareCommand = "/run/current-system/sw/bin/nextcloud-occ maintenance:mode --on";
    backupCleanupCommand = "/run/current-system/sw/bin/nextcloud-occ maintenance:mode --off && ${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_SPY";
    paths = [

      #TODO: revamp this
      # decide  how to backup jellyfin (firstly, /state or /persist? then, do we backup directly (ignoring ./metadata or copy the relevant stuff to /state/backups?
      #maybe only use /state/backups if the files to backup need preprocessing (i.e, cant be backed up directly, e.g sqlite, postgres data, etc)
      "/pst"
      "/data-spy/nextcloud-nixos"
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
  services.earlyoom.enable = false; #TODO: disable when monerod finish


  services.uptime-kuma = {
    settings = {
      PORT = "29377";
      HOST = "127.0.0.1";
    };
    enable = true;
  };

  environment.persistence."/state" = {
    hideMounts = true;
    directories = [
      "/var/db/sudo/lectured"
      "/var/log/journal"
    ];
    # users.rg = {
    #   directories = [
    #   ];
    # };
  };

  environment.etc."machine-id".source = "/state/etc/machine-id";
  environment.persistence."/pst" = {
    hideMounts = true;
    directories =
      [
        # "/root/.config/rclone"
      ];
    files = [ "/etc/machine-id" ];
    users.rg = {
      directories = [
        # ".config/rclone"
      ];
      files = [
        #see above comment
        # ".local/share/fish/fish_history"
        # ".local/share/zoxide/db.zo"
      ];
    };
  };


  services.gitea = {
    stateDir = "/data/gitea-nixos";
  };

  services.caddy.globalConfig = ''
    default_bind ${config.rg.ip}
  '';
  services.caddy.virtualHosts = {
    "git.${hostname}.rafael.ovh" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy unix//run/gitea/gitea.sock
      '';
    };
    "oldgit.${fqdn}" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:18172
      '';
    };
    "kuma.${fqdn}" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:29377
      '';
    };
    "router.${fqdn}" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://192.168.1.1:80
      '';
    };
    "cloud.${fqdn}" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${config.rg.ip}:5050
      '';
    };
  };

}
