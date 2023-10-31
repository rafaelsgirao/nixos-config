{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "medicpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5627-DE9B";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "medicpool/safe/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "medicpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/state" = {
    device = "medicpool/local/state";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "medicpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/pst" = {
    device = "medicpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  #Bind-mounts
  fileSystems."/etc/NetworkManager/system-connections" = {
    device = "/persist/etc/NetworkManager/system-connections";
    fsType = "none";
    options = [ "bind" ];
  };

  # fileSystems."/var/lib/libvirt" = {
  #   device = "/persist/var/lib/libvirt";
  #   fsType = "none";
  #   options = [ "bind" ];
  # };
  # fileSystems."/var/db/sudo/lectured" = {
  #   device = "/persist/var/db/sudo/lectured";
  #   fsType = "none";
  #   options = [ "bind" ];
  # };

  fileSystems."/home/rg/Screenshots" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
