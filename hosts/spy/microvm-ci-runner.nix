{ config, sshKeys, ... }:
let
  config' = config.microvm.vms.ci-runner.config;
in
{


  microvm.autostart = [ "ci-runner" ];
  microvm.vms = {

    ci-runner.specialArgs = {
      inherit sshKeys;
    };
    ci-runner.config = {


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
        ../../modules/ci/runner.nix
        ../../modules/core/ssh.nix
      ];
      microvm = {
        #Only works with QEMU user mode
        # forwardPorts = [
        #   { from = "host"; host.port = 2222; guest.port = 22; }
        # ];
        balloonMem = 2048;
        microvm.storeOnDisk = false;
        shares = [
          {
            proto = "virtiofs";
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          }
          {
            proto = "virtiofs";
            # tag = "ro-store";
            source = "/nix/";
            mountPoint = "/mnt/nix";
          }
          {
            proto = "virtiofs";
            tag = "ci-runner";
            source = "/var/lib/microvms/ci-runner/var-lib-ci-runner";
            mountPoint = "/var/lib/private/ci-runner";
          }
        ];
        volumes = [{
          mountPoint = "/var/lib/docker";
          image = "var-lib-docker.img";
          size = 1024 * 10;
        }
          {
            image = "nix-store-overlay.img";
            mountPoint = config'.microvm.writableStoreOverlay;
            size = 2048 * 10;
          }];
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



    };
  };
}
