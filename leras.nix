_:

{

  imports = [
  ];

  # TODOs:
  # use upstream nix instead of determinate
  # block outside caches

  home-manager.users.rg = {
    home.stateVersion = "25.05";
  };

  system.stateVersion = 6;
}
