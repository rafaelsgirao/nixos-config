{ modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      ../hardware/uefi.nix
      ../../modules/hardware/zfs.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  #Platform on which NixOS _should_ be built!
  # nixpkgs.buildPlatform = "x86_64-linux";

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/vda";
      content.type = "gpt";
      content.partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
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
    zpool.zpool = {
      type = "zpool";
      # mode = "TODO"; #TODO
      options = {
        ashift = "12";
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
          postCreateHook = "zfs snapshot zpool/local/root@blank";
          # options = {
          #   sync = "disabled";
          # };
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
