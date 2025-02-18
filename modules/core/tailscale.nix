_: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  environment.persistence."/pst".directories = [ "/var/lib/tailscale" ];
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
  };

}
