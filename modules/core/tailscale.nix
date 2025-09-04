{ lib, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraSetFlags = [ "--exit-node-allow-lan-access=true" ];
  };
  environment.persistence."/pst".directories = [ "/var/lib/tailscale" ];
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
  };
  systemd.services.tailscaled.serviceConfig = {
    LogLevelMax = "notice";
  };

}
