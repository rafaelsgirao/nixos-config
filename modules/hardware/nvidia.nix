{ config, ... }: {
  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfree = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    #    offload.enable = true;
    sync.enable = true;
    nvidiaBusId = "PCI:01:00:0";
    intelBusId = "PCI:00:02:0";
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
