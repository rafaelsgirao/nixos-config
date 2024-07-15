{ config, lib, ... }:

{
  rg = {
    class = "server";
    machineType = "virt";
  };
  imports = [
    ./consul.nix
    ../../modules/core/hardening.nix
    ../../modules/headless.nix
    ../../modules/impermanence.nix
  ];

  systemd.network.enable = true;
  systemd.network.networks."10-wan" =
    {
      # match the interface by name
      matchConfig.Name = "eth0";
      DHCP = "yes";

      # To add static addrs:
      address = [
        # configure addresses including subnet mask
        "${config.rg.ipv4}/24"
      ];
    };

  #--- the real stuff
  # services.garage = {
  #    enable = true;
  #    settings = {};
  # };


  #--- the real stuff END
  #--- FOR TESTING ONLY
  system.stateVersion = "24.05"; # Did you read the comment?
  hm.home.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.max-jobs = 1; # minimise local builds.
  nix.settings.cores = 1; # minimise local builds.
  networking.firewall.enable = lib.mkForce false; # FOR TESTING
  services.nebula.networks."rgnet".enable = lib.mkForce false;
  #--- FOR TESTING ONLY END
}
