{
  lib,
  config,
  pkgs,
  ...
}:
let
  isIntel = config.rg.machineType == "intel";
  isVirt = config.rg.machineType == "virt";
  # isAMD = config.rg.machineType == "amd";
  isWorkstation = config.rg.class == "workstation";
  inherit (lib) mkIf optional optionals;
in
{

  hardware.cpu.intel.updateMicrocode = isIntel;
  programs.cpu-energy-meter.enable = isIntel;

  services.fwupd.enable = !isVirt;

  hardware.enableRedistributableFirmware = !isVirt;

  environment.persistence."/state".directories = optionals (!isVirt) [
    "/var/lib/fwupd"
    "/var/cache/fwupd"
    "/var/cache/fwupdmgr"
  ];

  environment.systemPackages =
    optionals (!isVirt) [
      pkgs.smartmontools
      pkgs.nvme-cli
    ]
    ++ optional isIntel pkgs.intel-gpu-tools;

  hardware.graphics = mkIf (!isVirt) {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; lib.optionals isIntel [ intel-media-driver ];
  };

  #Enable SMARTd
  services.smartd = mkIf (!isVirt) {
    enable = true;
    autodetect = true;
    notifications = {
      test = !isWorkstation;
      mail = {
        sender = "machines@rafael.ovh";
        recipient = "rafaelgirao+smartd@proton.me";
      };
    };
  };

  # "modesetting" is replacing "intel", because the underlying package for intel was unmaintained.

  services.xserver.videoDrivers = lib.mkIf (isWorkstation && isIntel) [ "modesetting" ];

  boot.kernelModules = optionals isIntel [ "kvm-intel" ];

}
