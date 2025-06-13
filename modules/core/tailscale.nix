{ lib, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "client";
  };
  environment.persistence."/pst".directories = [ "/var/lib/tailscale" ];
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
  };

}
