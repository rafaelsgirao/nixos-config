{ sshKeys, ... }:
{

  users.users.nixremote = {
    openssh.authorizedKeys.keys = sshKeys;
    isNormalUser = true;
    group = "nogroup";

  };
  nix.settings.trusted-users = [ "nixremote" ];
}
