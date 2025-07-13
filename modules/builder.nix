{ pkgs, keys, ... }:
{

  users.users.nixremote = {
    openssh.authorizedKeys.keys = keys.users.rg;
    isSystemUser = true;
    group = "nogroup";
    shell = pkgs.bashInteractive;

  };
  nix.settings.trusted-users = [ "nixremote" ];
}
