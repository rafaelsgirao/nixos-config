{ sshKeys, ... }:
{


  microvm.autostart = [ "gitea-runner" ];
  microvm.vms = {

    gitea-runner.specialArgs = {
      inherit sshKeys;
    };
    gitea-runner.config = {


      networking.nameservers = [ "192.168.10.6" ];
      systemd.network.enable = true;

      systemd.network.networks."20-lan" = {
        matchConfig.Type = "ether";
        dns = [ "192.168.10.6" ];
        networkConfig = {
          IPv6AcceptRA = true;
          DHCP = "yes";
        };
      };

      networking.firewall.enable = false;
      boot.initrd.includeDefaultModules = false;
      environment.defaultPackages = [ ];

      users.users.root.openssh.authorizedKeys.keys = sshKeys;
      users.users.root.password = "1234";
      system.stateVersion = "23.11";
      environment.noXlibs = true;
      imports = [
        ../../modules/headless.nix
        ../../modules/docker.nix
        ../../modules/gitea-actions-runner.nix
        ../../modules/core/ssh.nix
      ];
      microvm = {
        #Only works with QEMU user mode
        # forwardPorts = [
        #   { from = "host"; host.port = 2222; guest.port = 22; }
        # ];
        shares = [
          {
            proto = "virtiofs";
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          }
        ];
        volumes = [{
          mountPoint = "/var/lib/docker";
          image = "var-lib-docker.img";
          size = 256;
        }];
        hypervisor = "cloud-hypervisor";
        socket = "control.socket";
        interfaces = [{
          type = "tap";

          # interface name on the host
          id = "vm-gitea-runner";

          # Ethernet address of the MicroVM's interface, not the host's
          #
          # Locally administered have one of 2/6/A/E in the second nibble.
          mac = "02:00:00:00:00:01";
        }];
      };



    };
  };
}
