{ config, pkgs, hostSecretsDir, ... }:

let
  domain = config.rg.domain;
  fqdn = config.networking.fqdn;
in
{
  imports = [
    # Include the results of the hardware scan.
    #      ./hardware-configuration.nix
    # (inputs.nixpkgs-unstable + "/nixos/modules/services/security/authelia.nix")
    ./wc-bot.nix
    ./vaultwarden.nix
    ./sirpt.nix
    ./bolsas.nix
    ./mailserver.nix
    ./caddy.nix
    # ./maddy.nix
    ../../modules/caddy.nix
    ../../modules/healthchecks.nix
    ../../modules/acme.nix
    ../../modules/blocky.nix
    ../../modules/zfs.nix
    ../../modules/docker.nix
    ../../modules/headless.nix
    ../../modules/sshguard.nix
    ../../modules/uefi.nix
  ];

  rg = {
    class = "server";
    machineType = "virt";
    ip = "192.168.10.9";
    ipv4 = "49.13.70.201";
    ipv6 = "2a01:4f8:c17:f044::1";
  };

  networking = {
    hostId = "f46e55a8";
    interfaces."eth0".ipv6 = {
      addresses = [{
        address = "2a01:4f8:c17:f044::1";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
  };

  networking.nameservers = [ config.rg.ip "1.1.1.1" ];

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

  #Home as tmpfs.
  # systemd.tmpfiles.rules = [ "d /home/rg 0755 rg users" ];

  #Root as 'tmpfs'.
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r ${config.networking.hostname}/local/root@blank
  '';

  environment.persistence."/pst" = {
    hideMounts = true;
    directories =
      [
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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    443 # Caddy-Public
    80 # caddy-public
    25 # Docker-mailserver
    143 # Docker-mailserver
    465 # Docker-mailserver
    587 # Docker-mailserver
    993 # Docker-mailserver
    4242 # Nebula lighthouse
    853 # blocky DNS over TLS


    4425 # Docker-mailserver
    44143 # Docker-mailserver
    44465 # Docker-mailserver
    44587 # Docker-mailserver
    44993 # Docker-mailserver
  ];
  networking.firewall.allowedUDPPorts = [
    443 #Caddy may eventually support QUIC
    853 # blocky DNS over TLS - should this be here?
    25 # Docker-mailserver
    143 # Docker-mailserver
    465 # Docker-mailserver
    587 # Docker-mailserver
    993 # Docker-mailserver
    4242 # Nebula lighthouse
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

  services.nebula.networks."rgnet" = {
    isLighthouse = true;
    lighthouses = [ ];
  };


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
