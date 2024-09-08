{ config, ... }:

# https://devopscube.com/setup-consul-cluster-guide/

#TODO: Consul backups
# https://developer.hashicorp.com/consul/tutorials/operate-consul/backup-and-restore
let
  inherit (config.rg) domain;

in
{
  services.consul = {
    enable = true;
    webUi = true;
    interface.bind = "eth0"; #nebula0 in production
    forceAddrFamily = "ipv4";
    interface.advertise = "eth0"; #nebula0 in production
    extraConfig = {
      client_addr = "0.0.0.0";
      bootstrap_expect = 3;
      datacenter = "vm";
      domain = "consul";
      encrypt = "Gj7Lt826mtt+bCujHT8cbJ3xFuwTCJzfnM73iAuBo70="; #change in prod! generate with `consul keygen`.
      server = true;
      log_level = "INFO";
      retry_join = [
        "192.168.122.40"
        "192.168.122.41"
        "192.168.122.42"
      ];
      dns_config = {
        enable_truncate = true;
        only_passing = true;
      };


    };
  };
  systemd.services.consul.serviceConfig.Type = "notify";

  #https://developer.hashicorp.com/consul/docs/install/ports
  networking.firewall.allowedTCPPorts = [
    8600
    8500
    8501
    8502
    8503
    8300
    8301
    8302

  ];
  networking.firewall.allowedUDPPorts = [
    8600
    8500
    8501
    8502
    8503
    8300
    8301
    8302

  ];

  environment.persistence."/pst" = {
    directories = [ "/var/lib/consul" ];
  };
}
