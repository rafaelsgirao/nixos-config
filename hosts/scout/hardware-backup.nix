# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    #    (inputs.nixos-hardware + "/lenovo/thinkpad/t480/default.nix")
  ];

  boot.initrd.availableKernelModules =
    #    [ "xhci_pci" "ahci" "nvme" "usbhid" "sdhci_pci" ];
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # fileSystems."/" = {
  #   device = "neonrgpool/local/root";
  #   fsType = "zfs";
  # };

  # fileSystems."/nix" = {
  #   device = "neonrgpool/local/nix";
  #   fsType = "zfs";
  # };

  # fileSystems."/var/lib/docker" = {
  #   device = "neonrgpool/local/docker";
  #   fsType = "zfs";
  # };

  # fileSystems."/home-state" = {
  #   device = "neonrgpool/safe/home";
  #   fsType = "zfs";
  # };

  # fileSystems."/home/rg/Screenshots" = {
  #   device = "none";
  #   fsType = "tmpfs";
  #   # options = [ "defaults" ];
  #   options = [ "defaults" "size=100M" "mode=700" ];
  # };

  # fileSystems."/pst" = {
  #   device = "neonrgpool/safe/persist";
  #   fsType = "zfs";
  #   neededForBoot = true;
  # };

  # fileSystems."/state" = {
  #   device = "neonrgpool/local/state";
  #   fsType = "zfs";
  #   neededForBoot = true;
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/BA5A-A170";
  #   fsType = "vfat";
  # };

  # swapDevices = [ ];

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  #Undervolt CPU
  # services.undervolt.enable = true;
  # services.undervolt.coreOffset = -80;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
