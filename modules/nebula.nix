{ lib, hostSecretsDir, config, ... }:
let
  inherit (config.rg) isLighthouse;
in
{


  age.secrets = {
    RGNet-CA = {
      file = "${hostSecretsDir}/../RGNet-CA.age";
      owner = "nebula-rgnet";
    };
    RGNet-cert = {
      file = "${hostSecretsDir}/RGNet-cert.age";
      owner = "nebula-rgnet";
    };
    RGNet-key = {
      file = "${hostSecretsDir}/RGNet-key.age";
      owner = "nebula-rgnet";
    };
  };

  users.users."nebula-rgnet".uid = 990;
  services.nebula.networks."rgnet" = {
    inherit isLighthouse;
    enable = true;
    cert = config.age.secrets.RGNet-cert.path;
    key = config.age.secrets.RGNet-key.path;
    tun.device = "nebula0";
    ca = config.age.secrets.RGNet-CA.path;
    lighthouses = if isLighthouse then (lib.mkDefault [ "192.168.10.3" "192.168.10.5" "192.168.10.9" ]) else [ ];
    settings = { cipher = "aes"; };
    listen.host = "[::]";
    staticHostMap = {
      "192.168.10.3" = [
        "62.171.137.229:4242"
        "[2a02:c207:2034:3449::1]:4242" # no wokr
      ];
      "192.168.10.5" =
        [ "193.136.132.93:4242" "[2001:690:2100:2:9f93:8e58:287f:c21]:4242" ];
      "192.168.10.9" =
        [ "128.140.110.89:4242" "[2a01:4f8:1c1e:aead::1]:4242" ];
    };
    firewall.outbound = [{
      host = "any";
      port = "any";
      proto = "any";
    }];
    firewall.inbound = [
      {
        host = "any";
        port = "any";
        proto = "any";
        groups = [ "rg" ];
      }
      {
        host = "any";
        port = "any";
        proto = "icmp";
      }
    ];
  };
  systemd.services."nebula@rgnet".unitConfig.StartLimitIntervalSec = lib.mkForce (if (config.rg.class == "workstation") then 20 else 10);

  #Firewall rule for Nebula Lighthouse.
  networking.firewall =
    {
      trustedInterfaces = [ "nebula0" ];
    }
    // lib.optionalAttrs config.rg.isLighthouse {
      allowedTCPPorts = [ 4242 ];
      allowedUDPPorts = [ 4242 ];
    };

}
