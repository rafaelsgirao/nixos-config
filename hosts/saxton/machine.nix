{ config, hostSecretsDir, lib, ... }:

let
  inherit (config.rg) domain;

in
{
  imports = [
    # Include the results of the hardware scan.
    #      ./hardware-configuration.nix
    # (inputs.nixpkgs-unstable + "/nixos/modules/services/security/authelia.nix")
    ./wc-bot.nix
    # ../../modules/ist-discord-bot.nix
    ../../modules/sshguard.nix
    ../../modules/hardware/uefi.nix
    ../../modules/vaultwarden.nix
    # ./sirpt.nix
    ../../modules/bolsas-scraper.nix
    # ./mailserver.nix
    ./caddy.nix
    # ./maddy.nix
    ../../modules/caddy.nix
    ../../modules/healthchecks.nix
    ../../modules/acme.nix
    ../../modules/blocky.nix
    ../../modules/zfs.nix
    # ../../modules/docker.nix
    ../../modules/headless.nix
    ../../modules/impermanence.nix
  ];

  rg = {
    class = "server";
    machineType = "virt";
    ip = "192.168.10.9";
    ipv4 = "128.140.110.89";
    ipv6 = "2a01:4f8:1c1e:aead::1";
    isLighthouse = true;
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIgLXN8cCbZ19eQtmtRsn1R1JEF0gg9lLYWajB2VeE6";
  };

  networking = {
    hostId = "f46e55a8";
    interfaces."eth0".ipv6 = {
      addresses = [{
        address = config.rg.ipv6;
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
  };

  networking.nameservers = [ config.rg.ip "1.1.1.1" ];

  #Root as 'tmpfs'.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r ${config.networking.hostName}/local/root@blank
  '';

  environment.persistence."/pst" = {
    files = [ "/etc/machine-id" ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    853 # blocky DNS over TLS
  ];
  networking.firewall.allowedUDPPorts = [
    853 # blocky DNS over TLS - should this be here?
  ];


  networking.hosts = {
    "127.0.0.1" = [ "localhost" config.networking.hostName ];
    "127.0.1.1" = [ "mail.${domain}" config.networking.hostName ];
  };

  # DNS overrides for Saxton for things that wouldn't make sense
  services.blocky.settings = {
    # logPrivacy = true;
    certFile = "/var/lib/acme/${domain}/fullchain.pem";
    keyFile = "/var/lib/acme/${domain}/key.pem";
    port = "${config.rg.ip}:53";
    tlsPort = 853;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  age.secrets = {
    "rclone.conf" = {
      file = "${hostSecretsDir}/../rclone-config.age";
    };
    restic-env = {
      file = "${hostSecretsDir}/../restic-env.age";
    };
    restic-password = {
      file = "${hostSecretsDir}/../restic-password.age";
    };
  };

  #TODO: still very incomplete
  # services.restic.backups."saxton-oneDriveIST" = {
  #   user = "root";
  #   repository = "rclone:oneDriveIST:/Restic-Backups";
  #   timerConfig = { OnCalendar = "*-*-* 5:00:00"; };
  #   rcloneConfigFile = config.age.secrets.rclone-config.path;
  #   environmentFile = config.age.secrets.restic-env.path;
  #   passwordFile = config.age.secrets.restic-password.path;

  #   backupCleanupCommand = "${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_SAXTON";

  #   paths = [
  #     "/data/bolsas-scraper"
  #     "/data/caddy-public" # Backup site
  #     "/state/backups"
  #     "/pst"
  #   ];
  #   extraBackupArgs = [ "--exclude-caches" "--verbose" ];
  # };



  # virtualisation.docker.daemon.settings = {
  #   "ipv6" = true;
  #   "fixed-cidr-v6" = "2001:db8:1::/64";
  # };

}
