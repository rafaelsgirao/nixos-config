_:
let
  hddCfg = _hddDev: {
    type = "disk";
    device = "/dev/disk/by-id/ata-SSD_2.5__512GB_InnovationIT_QLC_663122209170076";
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
      hoidpool = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "hoidpool";
        };
      };
    };
  };
in

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

  # Storage.
  disko.devices = {

    disk.hdd1 = hddCfg "/dev/disk/by-id/ata-Hitachi_HDS723030ALA640_MK0313YHG8X71C";
    disk.hdd2 = hddCfg "/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N7RE3H0C";

    zpool.hoidpool = {
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
          postCreateHook = "zfs snapshot hoidpool/local/root@blank";
        };
        "local/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
          postCreateHook = "zfs snapshot hoidpool/local/docker@blank";
        };
        "local/cache" = {
          type = "zfs_fs";
          mountpoint = "/var/cache";
          postCreateHook = "zfs snapshot hoidpool/local/cache@blank";
        };
        "local/library" = {
          type = "zfs_fs";
          mountpoint = "/var/library";
          postCreateHook = "zfs snapshot hoidpool/local/library@blank";
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
