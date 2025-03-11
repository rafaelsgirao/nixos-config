# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

let
  # disko is also used for importing pool at boot - can't change pool name like that :)
  # poolName = "${config.networking.hostName}pool";
  poolName = "zpool";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  rg.vCores = 8;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "uas"
    "nvme"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.throttled.enable = true;
  services.thermald.enable = true;

  # Storage.
  disko.devices = {
    disk.main = {
      type = "disk";
      #TODO: changeme: this is the NVME adapter, not the SSD itself
      device = "/dev/disk/by-id/nvme-WDC_PC_SN520_SDAPMUW-256G-1001_1835C2800054";
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
        "${config.networking.hostName}pool" = {
          size = "100%";
          content = {
            type = "zfs";
            pool = poolName;
          };
        };
      };
    };
    nodev."/home/rg/Screenshots" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=100M"
        "mode=700"
      ];
    };
    zpool."${poolName}" = {
      type = "zpool";
      # mode = "TODO"; #TODO
      options = {
        # the internet (and man zpoolprops) recommends ashift=12 but zpool status reports that
        # this value is not the best for WD blue SN580.
        # ashift=14 should be correct value: 1 << 14 = 16384B
        # see man zpoolprops for `ashift`
        ashift = "14";
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
