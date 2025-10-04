{ lib, ... }:
{

  programs.ssh.extraConfig = lib.mkForce { };
  hm = {
    programs.git.extraConfig = {
      commit.gpgSign = false;
      user = { };
      url = { };
    };
    programs.nixvim.plugins = lib.mkForce { };
  };
}
