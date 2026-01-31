{ lib, ... }:
let
  inherit (lib.rg) mkDisk;
  poolName = "jovianpool"; # Changing this after installation will cause in failed boots due to missing pool.
in

{
  imports = [
    ../../modules/hardware/bluetooth.nix
  ];

  rg.vCores = 8;

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

  hardware.cpu.amd.updateMicrocode = true;

  # Storage.
  disko.devices = {
    disk.main = mkDisk {
      inherit poolName;
      isBoot = true;
      #FIXME: this is the NVME adapter, not the SSD itself
      diskPath = "/dev/disk/by-id/usb-Realtek_RTL9210B-CG_012345679039-0:0";
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
        # "local/docker" = {
        #   type = "zfs_fs";
        #   mountpoint = "/var/lib/docker";
        #   postCreateHook = "zfs snapshot ${poolName}/local/docker@blank";
        # };
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
  fileSystems."/var/cache".neededForBoot = true;
}
