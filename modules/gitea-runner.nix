{ config, microvm, ... }: {
  imports = [ microvm.host ];

  environment.persistence."/state".directories = [ "/var/lib/microvms" ];
  #---------------
  #Networking.
  #---------------
  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Kind = "microvm";
    };
    networks."10-microvm" = {
      matchConfig.name = "microvm";
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

  #---------------
  #MicroVM configuration.
  #---------------
  microvm.vms = {
    my-microvm = {
      # The package set to use for the microvm. This also determines the microvm's architecture.
      # Defaults to the host system's package set if not given.
      # pkgs = import nixpkgs { system = "x86_64-linux"; };

      # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
      #specialArgs = {};

      # The configuration for the MicroVM.
      # Multiple definitions will be merged as expected.
      config = {
        # It is highly recommended to share the host's nix-store
        # with the VMs to prevent building huge images.
        imports = [

          ./modules/headless.nix
          ./modules/minimal.nix
        ];
        hypervisor = "cloud-hypervisor";
        microvm = {
          vcpu = 2;
          mem = 2048;
          baloonMem = 4096;
        };
        microvm.shares = [{
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }];

        # Any other configuration for your MicroVM
        # [...]
        services.gitea-action-runner.my-runner = { };
      };
    };
  };



}
