{ config, pkgs, lib, inputs, ... }: {
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

    trusted-substituters = [
      "https://cache.spy.rafael.ovh"
    ];

    trusted-public-keys = [
      "cache.spy.rafael.ovh:5aGgIOEo7H004XtJq5Bob59PiISlNCNH+m0v4IVyyCA="
    ];

    # Fallback quickly if substituters are not available.
    connect-timeout = 2;

    # The default at 10 is rarely enough.
    log-lines = lib.mkDefault 30;

    # Avoid disk full issues.
    max-free = lib.mkDefault (3000 * 1024 * 1024);
    min-free = lib.mkDefault (512 * 1024 * 1024);

    # Avoid copying unnecessary stuff over SSH
    builders-use-substitutes = true;

    flake-registry = ""; # Disable global flake registry
    warn-dirty = false;
  };
  nix.gc = {
    randomizedDelaySec = "45min";
    automatic = true;
    dates = if config.rg.isBuilder then "monthly" else "weekly";
    #Keep last 5 generations.
    options =
      let
        days = if config.rg.isBuilder then "60" else "15";
      in
      "--delete-older-than ${days}";
  };

  # Add nixpkgs input to NIX_PATH
  # This lets nix2 commands still use <nixpkgs>
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];



  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";



  #Security implications if true
  #... but with nix.settings.sandbox requires it....
  # security.allowUserNamespaces = lib.mkForce false;

  nix.distributedBuilds = !config.rg.isBuilder;

  programs.ssh.extraConfig = lib.mkIf (!config.rg.isBuilder) ''
    Host spybuilder
      HostName 192.168.10.6
    Port 22
    User rg
    # IdentitiesOnly yes
    # IdentityFile /root/.ssh/id_builder
  '';

  nix.buildMachines = lib.mkIf (!config.rg.isBuilder && config.rg.class == "workstation") [{
    sshUser = "rg";
    sshKey = "/home/rg/.ssh/id_ed25519";
    protocol = "ssh-ng";
    # publicHostKey = "bla";
    hostName = "192.168.10.6";
    systems = [ "x86_64-linux" "aarch64-linux" ];
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
}
