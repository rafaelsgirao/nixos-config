_: {
  imports = [
    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix

    ../../modules/headless.nix
    ../../modules/impermanence.nix
  ];

  rg = {
    machineId = "2139f7ce14c240c98a62b98c8078fe0d";
    machineType = "arm";
    class = "server";
    resetRootFs = true;
  };

  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "eth0";
    DHCP = "yes";
  };

  system.stateVersion = "26.05"; # Did you read the comment?
  hm.home.stateVersion = "26.05"; # Did you read the comment?
}
