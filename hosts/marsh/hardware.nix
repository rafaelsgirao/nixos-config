{ lib, inputs, ... }:
let
  inherit (lib.rg) mkDisk;
  poolName = "marshpool"; # Changing this after installation will cause in failed boots due to missing pool.
in

{
  imports = [ inputs.dgx-spark.nixosModules.dgx-spark ];

  hardware.dgx-spark.enable = true;

  # The dgx-spark module adds cache.flox.dev; these lists hold nothing else.
  nix.settings.extra-substituters = lib.mkForce [ ];
  nix.settings.extra-trusted-public-keys = lib.mkForce [ ];

  rg.vCores = 20;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "aarch64-linux";

  # Storage.
  rg.resetRootFsPoolName = poolName;
  disko.devices = {
    disk.main = mkDisk {
      inherit poolName;
      isBoot = true;
      #FIXME: replace with the /dev/disk/by-id path once booted off the installer
      diskPath = "/dev/nvme0n1";
    };

    zpool.${poolName} = {
      type = "zpool";
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
  fileSystems."/var/cache".neededForBoot = true;
}
