{ config, ... }:

{
  imports = [
  ];

  rg = {
    class = "server";
    machineType = "virt";
    ip = "192.168.10.10";
    # ipv4 = "128.140.110.89";
    # ipv6 = "2a01:4f8:1c1e:aead::1";
    # isLighthouse = true;
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIgLXN8cCbZ19eQtmtRsn1R1JEF0gg9lLYWajB2VeE6";
  };

  networking.hostId = "TODO";

  networking.nameservers = [ config.rg.ip "1.1.1.1" ];


  environment.persistence."/pst" = {
    # files = [ "/etc/machine-id" ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
  ];
  networking.firewall.allowedUDPPorts = [
  ];


  system.stateVersion = "23.05"; # Did you read the comment?

}
