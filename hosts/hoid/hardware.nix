{ lib, ... }:
let
  inherit (lib.rg) mkDisk;
  poolName = "zpool"; # Changing this after installation will cause in failed boots due to missing pool.
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
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.amdgpu.amdvlk.enable = true;

  hardware.cpu.amd.updateMicrocode = true;

  # Storage.
  disko.devices = {

    disk.hdd1 = mkDisk {
      inherit poolName;
      isBoot = true;
      diskPath = "/dev/disk/by-id/ata-Hitachi_HDS723030ALA640_MK0313YHG8X71C";

    };
    disk.hdd2 = mkDisk {
      inherit poolName;
      isBoot = false;
      diskPath = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N7RE3H0C";

    };

    zpool.zpool = {
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
          postCreateHook = "zfs snapshot zpool/local/root@blank";
        };
        "local/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
          postCreateHook = "zfs snapshot zpool/local/docker@blank";
        };
        "local/cache" = {
          type = "zfs_fs";
          mountpoint = "/var/cache";
          postCreateHook = "zfs snapshot zpool/local/cache@blank";
        };
        "local/library" = {
          type = "zfs_fs";
          mountpoint = "/var/library";
          postCreateHook = "zfs snapshot zpool/local/library@blank";
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
