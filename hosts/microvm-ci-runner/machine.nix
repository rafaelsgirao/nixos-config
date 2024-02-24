{ sshKeys, inputs, ... }:
{

  imports = [
    inputs.microvm.nixosModules.microvm
    ../../modules/core/default.nix
    ../../modules/headless.nix
    ../../modules/docker.nix
    ../../modules/ci/runner.nix
  ];

  rg = {
    ip = "0.0.0.0";
    machineType = "virt";
    class = "server";
    isBuilder = true;
    pubKey = "null";
  };

  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Name = "eth0";
    dns = [ "192.168.10.6" ];
    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "yes";
      IPForward = "yes";
    };
  };

  # networking.firewall.enable = false; # Having firewall disabled makes docker0 not work...?
  boot.initrd.includeDefaultModules = false;
  environment.defaultPackages = [ ];

  users.users.root.openssh.authorizedKeys.keys = sshKeys;
  users.users.root.password = "1234";
  system.stateVersion = "23.11";
  environment.noXlibs = true;
  # virtualisation.docker.daemon.settings = {
  #   dns = [ "192.168.10.6" "1.1.1.1" ];
  # };
  # virtualisation.docker.extraOptions = "--dns=192.168.10.6"; DONT SET BOTH THESE OPTIONS!
  microvm = rec {
    #Only works with QEMU user mode
    # forwardPorts = [
    #   { from = "host"; host.port = 2222; guest.port = 22; }
    # ];
    cpu = 2;
    balloonMem = 4096;
    mem = 4096;
    storeOnDisk = false;
    # https://wiki.installgentoo.com/index.php/PCI_passthrough#Memory_hugepages
    # hugepageMem = true;
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        proto = "virtiofs";
        tag = "host-nixvirtiofs";
        source = "/nix";
        mountPoint = "/mnt/nix";
      }
      # {
      #   proto = "virtiofs";
      #   tag = "ci-runner";
      #   source = "/var/lib/microvms/ci-runner/var-lib-ci-runner";
      #   mountPoint = "/var/lib/private/ci-runner";
      # }
      # {
      #   proto = "virtiofs";
      #   tag = "woodpecker-agent-state";
      #   source = "/var/lib/microvms/ci-runner/woodpecker-agent-state";
      #   mountPoint = "/etc/woodpecker";
      # }
      {
        proto = "virtiofs";
        tag = "woodpecker-agenix-secret";
        source = "${builtins.dirOf "/run/woodpecker-secrets/ENV-woodpecker"}";
        mountPoint = "${builtins.dirOf "/run/woodpecker-secrets/ENV-woodpecker"}";
      }
    ];
    volumes = [
      {
        mountPoint = "/var/lib/docker";
        image = "var-lib-docker.img";
        size = 1024 * 10;
      }
      {
        image = "nix-store-overlay.img";
        mountPoint = writableStoreOverlay;
        size = 2048 * 10;
      }
    ];
    writableStoreOverlay = "/nix/.rw-store";
    hypervisor = "cloud-hypervisor";
    socket = "control.socket";
    interfaces = [{
      type = "tap";

      # interface name on the host
      id = "vm-ci-runner";

      # Ethernet address of the MicroVM's interface, not the host's
      #
      # Locally administered have one of 2/6/A/E in the second nibble.
      mac = "02:00:00:00:00:01";
    }];
  };

}
