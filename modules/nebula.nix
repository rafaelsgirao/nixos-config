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
    lighthouses = lib.optionals (!isLighthouse) [ "192.168.10.9" ];
    settings = {
      cipher = "aes";
      pki = {
        blocklist = [
          "b2cc750cd2f6409f91f53d117fe9fa761549f09b005fb2c5f5b1ae59b5729b2d" #Medic (?).
          "54bd0a5c978cf0266c83fc0437ee62ba458b45c2835bd5cd2a576e8db07b500d" #Engie.
        ];
        disconnect_invalid = true;

      };
      listen = {
        send_recv_error = "private";
      };
      punchy = {
        respond = true;
      };
      tun = {
        drop_local_broadcast = false;
        drop_multicast = false;
      };
    };
    listen.host = "[::]";
    staticHostMap = {
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
