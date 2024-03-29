{ config, lib, ... }:

let
  inherit (config.rg) domain;

in
{
  imports = [
    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix

    ./wc-bot.nix
    # ../../modules/ist-discord-bot.nix
    ../../modules/docker.nix
    ../../modules/restic.nix
    ../../modules/sshguard.nix
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

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    # match the interface by name
    matchConfig.Name = "eth0";
    address = [
      # configure addresses including subnet mask
      "${config.rg.ipv6}/64"
      "${config.rg.ipv4}/32"
    ];
    routes = [
      # create default routes for both IPv6 and IPv4
      { routeConfig.Gateway = "fe80::1"; }
      {
        routeConfig = {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        };
      }
    ];
    # make the routes on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
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
  system.stateVersion = "23.11"; # Did you read the comment?

}
