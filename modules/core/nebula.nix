{
  lib,
  secretsDir,
  hostSecretsDir,
  config,
  ...
}:
let
  inherit (config.rg) isLighthouse;
  nebulaPort = config.services.nebula.networks."rgnet".settings.listen.port;
in
{

  age.secrets = lib.mkIf config.services.nebula.networks."rgnet".enable {
    RGNet-CA = {
      file = "${secretsDir}/RGNet-CA.age";
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
          "8146e435f083aecdf00f6ec976ce98aa2f9d6ae1682068aa1e5d41ef7cb02df0" # Scout.
          "b2cc750cd2f6409f91f53d117fe9fa761549f09b005fb2c5f5b1ae59b5729b2d" # Medic (?).
          "54bd0a5c978cf0266c83fc0437ee62ba458b45c2835bd5cd2a576e8db07b500d" # Engie.
        ];
        disconnect_invalid = true;

      };
      lighthouse = {
        local_allow_list = {
          interfaces = {
            # don't advertise docker IPs to lighthouse
            "docker.*" = false;
            "vbox.*" = false;
            "br-[0-9a-f]{12}" = false;
            "rnl0" = false;
            "virbr.*" = false;
          };
        };
      };
      listen = {
        send_recv_error = "private";
      };
      punchy = {
        punch = true;
        respond = true;
      };
      relay = {
        relays = [
          "192.168.10.5"
          "192.168.10.9"
        ];
      };
      tun = {
        drop_local_broadcast = false;
        drop_multicast = false;
      };
    };
    listen.host = "::";
    staticHostMap = {
      "192.168.10.9" = [
        "128.140.110.89:4242"
        "[2a01:4f8:1c1e:aead::1]:4242"
      ];
    };
    firewall.outbound = [
      {
        host = "any";
        port = "any";
        proto = "any";
      }
    ];
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
  systemd.services."nebula@rgnet".unitConfig.StartLimitIntervalSec = lib.mkForce (
    if (config.rg.class == "workstation") then 20 else 10
  );

  #Firewall rule for Nebula Lighthouse.
  networking.firewall =
    {
      trustedInterfaces = [ "nebula0" ];
    }
    // lib.optionalAttrs config.rg.isLighthouse {
      allowedTCPPorts = [
        4242
        nebulaPort
      ];
      allowedUDPPorts = [
        4242
        nebulaPort
      ];
    };

}
