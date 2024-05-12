{ config, pkgs, ... }: {

  # disable intel.
  # boot.blacklistedKernelModules = lib.mkIf (config.rg.class == "server") [ "i915" ];
  # hardware.nvidia = {
  #   prime = {
  #     #    offload.enable = true;
  #     sync.enable = true;
  #     nvidiaBusId = "PCI:01:00:0";
  #     intelBusId = "PCI:00:02:0";
  #   };
  # };
  # services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false; # requires PRIME to be set up
    };
    # open = true;
    nvidiaSettings = config.rg.class == "workstation";
  };

  hardware.opengl = {
    extraPackages = [
      pkgs.nvidia-vaapi-driver
    ];
  };
}
