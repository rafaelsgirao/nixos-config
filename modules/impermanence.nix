{ lib, config, ... }:
let
  isWorkstation = config.rg.class == "workstation";
in
{

  #Home as tmpfs.
  systemd.tmpfiles.rules = [ "d /home/rg 0755 rg users" ];


  environment.persistence."/state" = {
    directories = lib.mkIf isWorkstation [
      ".cache"
      ".cargo"
      ".rustup"
      ".cert"
    ];
  };
}
