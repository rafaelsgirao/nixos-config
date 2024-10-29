{ pkgs, ... }:
{

  # https://wiki.nixos.org/wiki/Podman
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;

    autoPrune.enable = true;
    autoPrune.dates = "monthly";
  };

  users.users.rg.extraGroups = [ "podman" ];
  # networking.networkmanager.unmanaged = [ "docker0" ];
  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    dive
  ];

  environment.persistence."/state".directories = [ "/var/lib/containers" ];

  # TODO: maybe?
  # services.udev.extraRules =
  #   lib.mkIf (config.rg.class == "workstation" && !config.virtualisation.docker.rootless.enable)
  #     ''
  #       SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl freeze docker.service --no-block"
  #       SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl thaw docker.service --no-block"
  #     '';
}
