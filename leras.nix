_:

{
  system.stateVersion = 6;

  imports = [
    ./profiles/common/nix.nix
  ];
  # TODOs:
  # use upstream nix instead of determinate
  # block outside caches
}
