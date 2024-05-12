{ lib, modulesPath, ... }: {

  environment.etc.machineId.text = "c2472bd717a44486adfdbc8e2f00199d";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # ../../modules/hardware/nvidia.nix
    # ../../modules/hardware/laptop.nix
  ];

  # services.tlp.settings = {
  #   CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "powersave";
  #   RUNTIME_PM_ON_AC = "auto";
  #   AHCI_RUNTIME_PM_ON_AC = "auto";
  #   WIFI_PWR_ON_AC = "on";
  # };

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
    neededForBoot = true;
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


  fileSystems."/nix" = {
    device = "neonheavypool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home-state" = {
    device = "neonheavypool/local/home-from-spypool";
    fsType = "zfs";
  };

  #Undervolt CPU
  # services.undervolt.enable = true;
  # services.undervolt.coreOffset = -80;

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
