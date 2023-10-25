{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "spypool/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CBD4-F1ED";
    fsType = "vfat";
  };

  fileSystems."/data-spy" = {
    device = "spypool/safe/data";
    fsType = "zfs";
  };

  fileSystems."/data" = {
    device = "neonheavypool/safe/data";
    fsType = "zfs";
  };

  fileSystems."/library" = {
    device = "neonheavypool/local/library";
    fsType = "zfs";
  };

  fileSystems."/home/rg/.config/rclone" = {
    device = "/persist/rclone-rg";
    fsType = "none";
    options = [ "bind" ];
  };


  fileSystems."/var/lib/private/uptime-kuma" = {
    device = "/data/uptime-kuma-nixos";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/root/.config/rclone" = {
    device = "/persist/rclone-root";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/state-heavy" = {
    device = "neonheavypool/local/state";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/state" = {
    device = "spypool/local/state";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/pst-heavy" = {
    device = "neonheavypool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/pst" = {
    device = "spypool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };


  fileSystems."/persist" = {
    device = "spypool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "spypool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home-state" = {
    device = "spypool/local/home";
    fsType = "zfs";
  };

  fileSystems."/data-spy/nextcloud-nixos/data/rg/files/PX" = {
    device = "/data/syncthing/st-sync/PX";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
