{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  environment.etc.machineId.text = "c2472bd717a44486adfdbc8e2f00199d";

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "uas" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "neonheavypool/local/root";
    fsType = "zfs";
  };

  fileSystems."/root-state-spypool" = {
    device = "spypool/local/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=512M" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DD26-F010";
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

  fileSystems."/var/monero" = {
    device = "neonheavypool/local/monero";
    fsType = "zfs";
  };

  fileSystems."/var/lib/private/uptime-kuma" = {
    device = "/data/uptime-kuma-nixos";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/state-heavy" = {
    device = "neonheavypool/local/state";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/state" = {
    device = "neonheavypool/local/state";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/pst-heavy" = {
    device = "neonheavypool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/pst" = {
    device = "neonheavypool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };


  fileSystems."/persist" = {
    device = "neonheavypool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "neonheavypool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home-state" = {
    device = "neonheavypool/local/home-from-spypool";
    fsType = "zfs";
  };

  # fileSystems."/data-spy/nextcloud-nixos/data/rg/files/PX" = {
  #   device = "/data/syncthing/st-sync/PX";
  #   fsType = "none";
  #   options = [ "bind" ];
  # };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
