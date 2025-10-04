{
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault;
in

{
  # Credits to this awesome person for (most of) these:
  # https://git.sr.ht/~misterio/nix-config/tree/main/item/hosts/common/global/nix.nix

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  };

  nix.settings =
    # let
    # nixCores = max (config.rg.vCores - 2) 1;
    # nixJobs = max ((config.rg.vCores - 2) / 2) 1;
    # in
    {
      # max-jobs = mkDefault nixJobs;
      # cores = mkDefault nixCores;

      download-buffer-size = 536870912;

      # Experimental Determinate Nix feature
      # lazy-trees = true;

      # Enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];

      fallback = true;

      # being in trusted-users has the same security implications as being in docker group!
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-trusted-users
      # Thanks @diogotcorreia
      trusted-users = [ ];

      substituters = [
        "https://cache.rsg.ovh/rgnet"
      ];
      trusted-substituters = [ "https://cache.rsg.ovh/rgnet" ];

      trusted-public-keys = [
        "rgnet:KGvhLKw9yQzWbzy+/+KiTCFMqyOCxN12c0Cf/mk+dwE="
      ];

      # Fallback quickly if substituters are not available.
      connect-timeout = 1;

      # The default at 10 is rarely enough.
      log-lines = mkDefault 30;

      # Avoid disk full issues.
      max-free = mkDefault (3000 * 1024 * 1024);
      min-free = mkDefault (512 * 1024 * 1024);

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;

      flake-registry = ""; # Disable global flake registry
      warn-dirty = false;
      use-xdg-base-directories = true;
    };

  # Add nixpkgs input to NIX_PATH
  # This lets nix2 commands still use <nixpkgs>
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];

  nix.distributedBuilds = mkDefault true;

  programs.ssh.extraConfig = ''
    Host hoid
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/rg/.ssh/id_ed25519
      ControlMaster auto
      ControlPath ~/.ssh--master-%r@%n:%p
      ControlPersist 10m


    Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/rg/.ssh/id_ed25519
      ControlMaster auto
      ControlPath ~/.ssh--master-%r@%n:%p
      ControlPersist 10m

    Host lab*p*.rnl.tecnico.ulisboa.pt
      AddressFamily inet
      User ist199309
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/rg/.ssh/id_ed25519
      ProxyJump borg
      ControlMaster auto
      ControlPath ~/.ssh--master-%r@%n:%p
      ControlPersist 10m

    Host borg borg.rnl.tecnico.ulisboa.pt
      AddressFamily inet
      User ist199309
      HostName borg.rnl.tecnico.ulisboa.pt
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/rg/.ssh/id_ed25519
      ControlMaster auto
      ControlPath ~/.ssh--master-%r@%n:%p
      ControlPersist 10m
  '';

  nix.buildMachines = [
    {
      hostName = "hoid";
      sshUser = "nixremote";
      protocol = "ssh-ng";
      maxJobs = 10;
      systems = [
        "i686-linux"
        "x86_64-linux"
        "aarch64-linux"
      ];
      speedFactor = 10;
      supportedFeatures = [
        "benchmark"
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];

  #TODO: disable heavy supported-features on non-builders (but locally, not remote builders!)
  # One nixbuild.net entry per 'system'.
}
