{
  inputs,
  pkgs,
  profiles,
  ...
}:
{

  imports = [
  ];

  environment.shells = [ pkgs.fish ];
  system.primaryUser = "rg";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs profiles;
    };
  };
  users.users.rg.home = "/Users/rg"; # Needed by home-manager. Took way to looong to figure this out :)

  home-manager.users.rg = {
    imports = [
      profiles.home.default
    ];

  };
  #
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
