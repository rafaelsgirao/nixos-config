{
  config,
  pkgs,
  lib,
  ...
}:
{

  virtualisation.containers.enable = true;

  virtualisation.docker = {
    enable = lib.mkDefault true;
    daemon.settings.shutdown-timeout = 120;
  };
  networking.networkmanager.unmanaged = [ "docker0" ];
  environment.systemPackages = with pkgs; [ docker-compose ];

  #TODO: be careful about ist-discord-bot @ sazed!
  #NOTE: this. is. so. painful! please don't use this in the future.
  # You have been warned.
  # virtualisation.docker.rootless = lib.mkIf (config.rg.class == "workstation") {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  services.udev.extraRules =
    lib.mkIf (config.rg.class == "workstation" && !config.virtualisation.docker.rootless.enable)
      ''
        SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl freeze docker.service --no-block"
        SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl thaw docker.service --no-block"
      '';
}
