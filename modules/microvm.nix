{ inputs, ... }: {

  environment.persistence."/state".directories = [
    "/var/lib/microvms"
  ];

  imports = [
    inputs.microvm.nixosModules.host
  ];

  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = "microvm";
    };
    networks."10-microvm" = {
      matchConfig.Name = "microvm";
      networkConfig = {
        DHCPServer = true;
        IPv6SendRA = true;
      };
      addresses = [{
        addressConfig.Address = "10.0.0.1/24";
      }
        {
          addressConfig.Address = "fd12:3456:789a::1/64";
        }];
      ipv6Prefixes = [{
        ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
      }];
    };
    networks."11-microvm" = {
      matchConfig.Name = "vm-*";
      # Attach to the bridge that was configured above
      networkConfig.Bridge = "microvm";
    };
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    # Change this to the interface with upstream Internet access
    externalInterface = "eth0";
    internalInterfaces = [ "microvm" ];
  };
  networking.firewall.trustedInterfaces = [ "microvm" ];

}
