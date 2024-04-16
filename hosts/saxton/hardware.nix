{ modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "aarch64-linux";
  #Platform on which NixOS _should_ be built!
  # nixpkgs.buildPlatform = "x86_64-linux";

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
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
        saxtonpool = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "saxton";
          };
        };
      };
    };
    zpool.saxton = {
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
          postCreateHook = "zfs snapshot saxton/local/root@blank";
          # options = {
          #   sync = "disabled";
          # };
        };
        "local/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
          # options = {
          #   sync = "disabled";
          # };
        };
        "local/cache" = {
          type = "zfs_fs";
          mountpoint = "/var/cache";
          # options = {
          #   sync = "disabled";
          # };
        };
        "local/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          # options = {
          #   sync = "disabled";
          # };

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
    # nodev."/" = {
    #     fsType = "tmpfs";
    #     mountOptions = [ "size=2G" "defaults" "mode=755" ];
    # };
  };
  fileSystems."/pst".neededForBoot = true;
  fileSystems."/state".neededForBoot = true;
}
