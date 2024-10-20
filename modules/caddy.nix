{ config, ... }:
{
  services.caddy = {
    enable = true;
    inherit (config.security.acme.defaults) email;
  };

  systemd.services.caddy = {
    wants = [ "nebula@rgnet.service" ];
    after = [ "nebula@rgnet.service" ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    443 # Caddy-Public
    80 # caddy-public
  ];
  networking.firewall.allowedUDPPorts = [
    443 # Caddy may eventually support QUIC
  ];

  users.users.rg.extraGroups = [ "caddy" ];

  environment.persistence."/state".directories = [ "/var/lib/caddy" ];
}
