{ config, ... }: {
  services.caddy = {
    enable = true;
    inherit (config.security.acme.defaults) email;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    443 # Caddy-Public
    80 # caddy-public
  ];
  networking.firewall.allowedUDPPorts = [
    443 #Caddy may eventually support QUIC
  ];

  users.users.rg.extraGroups = [ "caddy" ];
}
