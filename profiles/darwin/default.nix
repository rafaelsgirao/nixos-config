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

  fonts.packages = with pkgs; [
    roboto
    noto-fonts-cjk-sans
    noto-fonts-extra
    noto-fonts-emoji
    font-awesome
    #    powerline-fonts
    source-code-pro
    overpass
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.fantasque-sans-mono
  ];

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

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  # TODO: nix-darwin 25.11
  # networking.applicationFirewall = {
  #   enable = true;
  #   blockAllIncoming = true;
  #
  # };

  nix.channel.enable = false;

  nix.daemonIOLowPriority = true;
  programs.fish.enable = true; # for /etc/shells entry to work

  # TODO:
  # - gc
  # - linux-builder?
  # - store optimizer (ig putting nix stuff I already have as commmon)
}
