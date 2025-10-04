{ lib, ... }:
{

  programs.ssh.extraConfig = lib.mkForce { };
}
