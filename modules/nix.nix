{ pkgs, lib, inputs, ... }: {
  # Credits to this awesome person for (most of) these:
  # https://git.sr.ht/~misterio/nix-config/tree/main/item/hosts/common/global/nix.nix

  #Enable use of Flakes.
  nix.package = pkgs.nixFlakes;

  # Add each flake input as a registry
  # To make nix3 commands consistent with the flake
  nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

  nix.settings = {
    # Enable flakes
    experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
      "repl-flake"
    ];

    trusted-users = [ "@wheel" "root" ];

    # Fallback quickly if substituters are not available.
    connect-timeout = 5;

    # The default at 10 is rarely enough.
    log-lines = lib.mkDefault 30;

    # Avoid disk full issues
    max-free = lib.mkDefault (3000 * 1024 * 1024);
    min-free = lib.mkDefault (512 * 1024 * 1024);

    # Avoid copying unnecessary stuff over SSH
    builders-use-substitutes = true;

    flake-registry = ""; # Disable global flake registry
    warn-dirty = false;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    #Keep last 5 generations.
    options = "--delete-older-than +5";
  };

  # Add nixpkgs input to NIX_PATH
  # This lets nix2 commands still use <nixpkgs>
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
}
