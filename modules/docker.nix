{ pkgs, lib, ... }: {
  virtualisation.docker = {
    enable = lib.mkDefault true;
    daemon.settings.shutdown-timeout = 120;
  };
  networking.networkmanager.unmanaged = [ "docker0" ];
  environment.systemPackages = with pkgs; [ docker-compose ];
  users.users.rg.extraGroups = [ "docker" ];
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketvariable = true;
  # };

}
