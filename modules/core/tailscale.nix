_: {
  services.tailscale = {
    enable = true;

    openFirewall = true;

    environment.persistence."/pst".directories = [ "/var/lib/tailscale" ];
  };

}
