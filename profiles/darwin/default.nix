{ self, ... }:
{

  imports = [
    "${self}/profiles/common/nix.nix"
  ];

  system.primaryUser = "rg";

  homebrew = {
    enable = true;
  };

  # TODO: nix-darwin 25.11
  # networking.applicationFirewall = {
  #   enable = true;
  #   blockAllIncoming = true;
  #
  # };

  nix.channel.enable = false;

  nix.daemonIOLowPriority = true;

  # TODO:
  # - gc
  # - linux-builder?
  # - store optimizer (ig putting nix stuff I already have as commmon)
}
