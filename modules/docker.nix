{ config, pkgs, lib, ... }: {
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

  services.udev.extraRules = lib.mkIf (config.rg.class == "workstation") ''
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl freeze docker.service"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl thaw docker.service"
  '';
}
