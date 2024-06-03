{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    #    (inputs.nixos-hardware + "/lenovo/thinkpad/t480/default.nix")
  ];

  boot.initrd.availableKernelModules =
    #    [ "xhci_pci" "ahci" "nvme" "usbhid" "sdhci_pci" ];
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = "powersave";

  nixpkgs.hostPlatform = "x86_64-linux";


  # Storage.
  disko.devices = {
    disk.main = {
      type = "disk";
      # device = "/dev/disk/by-id/ata-WDC_PC_SN520_SDAPMUW-256G-1001_1835C2800054"; #TODO: change later
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
        sazedpool = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "zpool";
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
    zpool.zpool = {
      type = "zpool";
      # mode = "TODO"; #TODO
      options = {
        ashift = "12";
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

  # Mount legacy partitions.
  # fileSystems."/home-state" = {
  #   device = "neonrgpool/safe/home";
  #   fsType = "zfs";
  # };

  fileSystems."/pst".neededForBoot = true;
  fileSystems."/state".neededForBoot = true;
}

