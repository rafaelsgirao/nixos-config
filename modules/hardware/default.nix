{ lib, config, pkgs, ... }:
let
  isIntel = config.rg.machineType == "intel";
  isVirt = config.rg.machineType == "virt";
  # isAMD = config.rg.machineType == "amd";
  isWorkstation = config.rg.class == "workstation";
  inherit (lib) mkIf optional optionals;
in
{

  hardware.cpu.intel.updateMicrocode = isIntel;

  services.fwupd.enable = !isVirt;

  environment.systemPackages = optionals (!isVirt)
    [
      pkgs.smartmontools
      pkgs.nvme-cli
    ]
  ++ optional isIntel pkgs.intel-gpu-tools;

  hardware.opengl = mkIf (!isVirt) {
    enable = true;
    driSupport = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; lib.optionals (isIntel) [
      intel-media-driver
      intel-ocl
    ];
  };

  #Enable SMARTd
  services.smartd = mkIf (!isVirt) {
    enable = true;
    autodetect = true;
    notifications = {
      test = lib.mkDefault false;
      mail = {
        sender = "machines@rafael.ovh";
        recipient = "rafaelgirao+smartd@proton.me";
      };
    };
  };

  services.xserver.videoDrivers = lib.mkIf (isWorkstation && isIntel) [ "intel" ];

  boot.kernelModules = optionals isIntel [ "kvm-intel" ];

}
