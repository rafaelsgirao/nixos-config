{ lib, config, ... }:
let
  isWorkstation = config.rg.class == "workstation";
in
{

  #Home as tmpfs.



  environment.persistence."/state" = {
    hideMounts = true;
    directories = [
      "/var/log/journal"
    ];
    users.rg.directories = lib.mkIf isWorkstation
      [
        ".cache"
        ".cert"
      ];
  };

  environment.persistence."/pst" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
    ];
  };
}
