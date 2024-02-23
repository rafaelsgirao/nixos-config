{ config'
, lib
, pkgs
, inputs
, ...
}:
let
  inherit (config'.rg) ip;
  grpcPort = 32467;
in
{

  services.woodpecker-agents.agents.runner = {
    enable = true;
    package = pkgs.unstable.woodpecker-agent;
    path = with pkgs; [ bash coreutils git git-lfs config'.nix.package woodpecker-plugin-git ];
    environment = {
      WOODPECKER_BACKEND = "local";
      WOODPECKER_SERVER = "${ip}:${builtins.toString grpcPort}";
      # WOODPECKER_BACKEND_DOCKER_VOLUMES = "/mnt/nix:/nix";
      # WOODPECKER_BACKEND_DOCKER_NETWORK = "bridge";
      # WOODPECKER_AUTHENTICATE_PUBLIC_REPOS = "true";

    };
    environmentFile = [ config'.age.secrets.ENV-woodpecker.path ];
  };
  # systemd.services."woodpecker-agent-runner".serviceConfig = {
  #   SupplementaryGroups = [ "docker" ];
  # };

  #Nix settings


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

    substituters = [
      "https://cache.spy.rafael.ovh"
    ];
    trusted-substituters = config'.nix.settings.substituters;

    trusted-public-keys = [
      "cache.spy.rafael.ovh:5aGgIOEo7H004XtJq5Bob59PiISlNCNH+m0v4IVyyCA="
    ];

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

}
