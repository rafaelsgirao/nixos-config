{ lib, config, ... }:
let
  isWorkstation = config.rg.class == "workstation";
in
{

  #Home as tmpfs.
  systemd.tmpfiles.rules = [ "d /home/rg 0755 rg users" ];


  environment.persistence."/state" = {
    hideMounts = true;
    directories = [
      "/var/log/journal"
    ];
    users.rg.directories = lib.mkIf isWorkstation
      [
        ".cache"
        ".cargo"
        ".rustup"
        ".cert"
      ];
  };
}
