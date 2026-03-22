{ lib, ... }:
let
  inherit (lib.rg) mkDisk;
  poolName = "razerpool"; # Changing this after installation will cause in failed boots due to missing pool.
in

{
  imports = [
    ../../modules/hardware/bluetooth.nix
  ];

  rg.vCores = 16;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "igc"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # hardware.amdgpu.amdvlk.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  # Storage.
  disko.devices = {

    disk.nvme1 = mkDisk {
      inherit poolName;
      isBoot = true;
      diskPath = "/dev/disk/by-id/nvme-CT4000P310SSD8_25184FF24E8E";

    };
    disk.nvme2 = mkDisk {
      inherit poolName;
      isBoot = false;
      diskPath = "/dev/disk/by-id/nvme-CT4000P310SSD8_25184FF24F56_1";

    };

    zpool.${poolName} = {
      type = "zpool";
      mode = "mirror";
      options = {
        ashift = "12";
        autoexpand = "on";
        failmode = "continue";
      };
      # man zfsprops
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        canmount = "off";
        compression = "zstd";
        dnodesize = "auto";
        normalization = "formD";
        xattr = "sa";
        mountpoint = "none";
        encryption = "on";
        keyformat = "passphrase";
        keylocation = "prompt";
      };
      datasets = {
        "local" = {
          type = "zfs_fs";
          options = {
            sync = "disabled";
          };
        };
        "local/root" = {
          type = "zfs_fs";
          mountpoint = "/";
          postCreateHook = "zfs snapshot ${poolName}/local/root@blank";
        };
        "local/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
          postCreateHook = "zfs snapshot ${poolName}/local/docker@blank";
        };
        "local/cache" = {
          type = "zfs_fs";
          mountpoint = "/var/cache";
          postCreateHook = "zfs snapshot ${poolName}/local/cache@blank";
        };
        "local/library" = {
          type = "zfs_fs";
          mountpoint = "/var/library";
          postCreateHook = "zfs snapshot ${poolName}/local/library@blank";
        };
        "local/monero" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/monero";
        };
        "local/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        "local/reserved" = {
          type = "zfs_fs";
          options = {
            mountpoint = "none";
            # https://wiki.nixos.org/wiki/ZFS#Reservations
            refreservation = "20G";
          };
        };
        "local/state" = {
          type = "zfs_fs";
          mountpoint = "/state";
        };
        "safe/persist" = {
          type = "zfs_fs";
          mountpoint = "/pst";
        };
      };
    };
  };

  fileSystems."/pst".neededForBoot = true;
  fileSystems."/state".neededForBoot = true;
}
