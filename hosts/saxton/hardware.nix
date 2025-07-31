{ lib, modulesPath, ... }:
let
  poolName = "saxton";
  inherit (lib.rg) mkDisk;
in

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "usbhid"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  rg.vCores = 2;
  rg.resetRootFsPoolName = poolName;
  nixpkgs.hostPlatform = "aarch64-linux";
  #Platform on which NixOS _should_ be built!
  # nixpkgs.buildPlatform = "x86_64-linux";

  disko.devices = {
    disk.main = mkDisk {
      inherit poolName;
      isBoot = true;
      diskPath = "/dev/sda";
    };

    zpool.saxton = {
      type = "zpool";
      # mode = "TODO"; #TODO
      options = {
        ashift = "12";
        autoexpand = "on";
        failmode = "continue";
      };
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
          postCreateHook = "zfs snapshot saxton/local/root@blank";
        };
        "local/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
        };
        "local/cache" = {
          type = "zfs_fs";
          mountpoint = "/var/cache";
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
}
