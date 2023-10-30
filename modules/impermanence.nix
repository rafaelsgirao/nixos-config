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
    ]
    ++ lib.optionals isWorkstation [
      ".cache"
      ".cargo"
      ".rustup"
      ".cert"
    ];
  };
