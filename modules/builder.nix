{ pkgs, sshKeys, ... }:
{

  users.users.nixremote = {
    openssh.authorizedKeys.keys = sshKeys;
    isSystemUser = true;
    group = "nogroup";
    shell = pkgs.bashInteractive;

  };
  nix.settings.trusted-users = [ "nixremote" ];
}
