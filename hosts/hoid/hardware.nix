{ ... }:
# let
#   hddCfg = hddDev: {
#     type = "disk";
#     device = "${hddDev}";
#     content.type = "gpt";
#     content.partitions = {
#       ESP = {
#         size = "512M";
#         type = "EF00";
#         priority = 1; # Needs to be first partition
#         content = {
#           type = "filesystem";
#           format = "vfat";
#           mountpoint = "/boot";
#         };
#       };
#       zpool = {
#         size = "100%";
#         content = {
#           type = "zfs";
#           pool = "zpool";
#         };
#       };
#     };
#   };
# in

{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    # ../../modules/hardware/bluetooth.nix
    #TODO
  ];

  rg.vCores = 16;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = true;

  # TODO: refactor this. only thing that changes is mountpoint and device
  # Storage.
  disko.devices = {

    # disk.hdd1 = hddCfg "/dev/disk/by-id/ata-Hitachi_HDS723030ALA640_MK0313YHG8X71C";
    # disk.hdd2 = hddCfg "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N7RE3H0C";
    disk.hdd1 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N7RE3H0C";
      content.type = "gpt";
      content.partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          priority = 1; # Needs to be first partition
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        zpool = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "zpool";
          };
        };
      };
    };
    disk.hdd2 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Hitachi_HDS723030ALA640_MK0313YHG8X71C";
      content.type = "gpt";
      content.partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          priority = 1; # Needs to be first partition
          content = {
            type = "filesystem";
            format = "vfat";
            # mountpoint = "/boot";
          };
        };
        zpool = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "zpool";
          };
        };
      };
    };

    zpool.zpool = {
      type = "zpool";
      mode = "mirror"; # TODO
      options = {
        ashift = "12";
        autoexpand = "on";
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
            refreservation = "2G";
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
