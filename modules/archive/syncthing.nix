{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.networking) fqdn;
  isWorkstation = config.rg.class == "workstation";
in
{
  #Sysctl rules
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 204800;
  };

  services.syncthing = {
    enable = true;
    overrideFolders = false;
    overrideDevices = false;
    extraOptions = {
      gui = {
        theme = "dark";
      };
    };
    openDefaultPorts = true;
    user = lib.mkIf isWorkstation "rg";
    dataDir = "/pst/syncthing-data";
    configDir = "/pst/syncthing-config";
  };

  fileSystems."/home/rg/Syncthing" = lib.mkIf isWorkstation {
    device = config.services.syncthing.dataDir;
    fsType = "none";
    options = [ "bind" ];
  };

  # home.file.syncthing-px = lib.mkIf isWorkstation {
  #   enable = true;
  #   # source = lib.file.mkOutOfStoreSymlink config.age.secrets.wakatime-cfg.path;
  #   source = config.lib.file.mkOutOfStoreSymlink "/home/rg/Syncthing/PX";
  #   target = "PX";
  # };

  services.udev.extraRules = lib.mkIf isWorkstation ''
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl freeze syncthing.service"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl thaw syncthing.service"
  '';

  users.users.rg.extraGroups = [ "syncthing" ];

  #RESTIC
  # "--exclude '/data/syncthing/st-sync/config/index*-db'"

  services.caddy.virtualHosts."syncthing.${fqdn}" = lib.mkIf (!isWorkstation) {
    useACMEHost = "rafael.ovh";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:8384
    '';
  };
}
