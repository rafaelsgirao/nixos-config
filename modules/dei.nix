{
  config,
  lib,
  secretsDir,
  ...
}:

let
  RNLCert = builtins.fetchurl {
    url = "https://rnl.tecnico.ulisboa.pt/ca/cacert/cacert.pem";
    sha256 = "1jiqx6s86hlmpp8k2172ki6b2ayhr1hyr5g2d5vzs41rnva8bl63";
  };
in
{

  security.pki.certificateFiles = [ "${RNLCert}" ];
  age.secrets = {
    RNLDEI-wg = {
      file = "${secretsDir}/RNLDEI-wireguard.age";
      owner = "root";
      group = "systemd-network";
      mode = "0640";
    };
  };
  networking.networkmanager.unmanaged = [ "rnl0" ];
  networking.firewall.checkReversePath = "loose";
  systemd.network =
    let
      wgrnlFwmark = 765;
    in
    {
      enable = true;

      config.routeTables.rnl = 765;

      netdevs."10-wgrnl" = {
        enable = true;
        netdevConfig = {
          Kind = "wireguard";
          MTUBytes = "1300";
          Name = "rnl0";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.RNLDEI-wg.path;
          FirewallMark = wgrnlFwmark;
          RouteTable = "rnl";
        };
        wireguardPeers = [
          {

            PublicKey = "g08PXxMmzC6HA+Jxd+hJU0zJdI6BaQJZMgUrv2FdLBY=";
            # TODO: missing IPv6 endpoint
            Endpoint = "193.136.164.211:34266";
            AllowedIPs = [
              # public RNL-operated ranges
              "193.136.164.0/24"
              "193.136.154.0/24"
              "2001:690:2100:80::/58"

              # public 3rd-party ranges
              "193.136.128.24/29" # DSI-RNL peering
              "146.193.33.81/32" # INESC watergate

              # private RNL-operated ranges
              "10.16.64.0/18"
              "192.168.154.0/24" # Labs AMT
              "192.168.20.0/24" # wgrnl VPN
              "fd92:3315:9e43:c490::/64" # wgrnl VPN

              # multicast
              "224.0.0.0/24"
              "ff02::/16"
              "239.255.255.250/32"
              "239.255.255.253/32"
              "fe80::/10"
            ];
            PersistentKeepalive = 25;
          }
        ];
      };
      networks."45-rnl" = {
        name = "rnl0";

        addresses = [
          { Address = "192.168.20.75/24"; }
          {
            Address = "fd92:3315:9e43:c490::75/64";
            DuplicateAddressDetection = "none";
          }
        ];

        networkConfig = {
          LinkLocalAddressing = "no";
          IPv6AcceptRA = false;
          #MulticastDNS = true;
        };

        linkConfig = {
          Multicast = true;
          #AllMulticast = true;
        };

        routingPolicyRules = [
          {
            InvertRule = true;
            FirewallMark = wgrnlFwmark;
            Table = "rnl";
            Family = "both";
          }
        ];

        ntp = [ "ntp.rnl.tecnico.ulisboa.pt" ];

        dns = [
          "2001:690:2100:80::1"
          "193.136.164.2"
          "2001:690:2100:80::2"
          "193.136.164.1"
        ];
        domains =

          # https://gist.github.com/brasey/fa2277a6d7242cdf4e4b7c720d42b567
          [
            # Main domain
            "~rnl.tecnico.ulisboa.pt"

            # alt domains
            # "~rnl.ist.utl.pt"
            # "~rnl.pt"

            # public ranges (DSI-assigned)
            "~164.136.193.in-addr.arpa"
            "~154.136.193.in-addr.arpa"
            "~8.0.0.0.0.1.2.0.9.6.0.1.0.0.2.ip6.arpa"

            # private ranges (wgrnl VPN)
            "~20.168.192.in-addr.arpa"
            "~0.9.4.c.3.4.e.9.5.1.3.3.2.9.d.f.ip6.arpa"

            # private range (Labs AMT)
            "~154.168.192.in-addr.arpa"
          ]
          ++ (
            # private ranges (DSI-assigned)
            builtins.map (octet: "~" + (builtins.toString octet) + ".16.10.in-addr.arpa") (lib.range 64 127)
          );
      };
    };

}
