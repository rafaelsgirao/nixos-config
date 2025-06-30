{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (config.rg) domain;
in

{
  # Credits to this awesome person for (most of) these:
  # https://git.sr.ht/~misterio/nix-config/tree/main/item/hosts/common/global/nix.nix

  # Add each flake input as a registry
  # To make nix3 commands consistent with the flake
  # Only adding each flake input to the registry in workstations,
  # Since all registries add ~200-400MB to each system's closure.
  nix.registry =
    if (config.rg.class == "workstation") then
      lib.mapAttrs (_: value: { flake = value; }) inputs
    else
      { nixpkgs.flake = inputs.nixpkgs; };

  nix.daemonIOSchedClass = "idle";
  nix.daemonCPUSchedPolicy = "idle";
  nix.settings =
    let
      nixCores = lib.max (config.rg.vCores - 2) 1;
      nixJobs = lib.max ((config.rg.vCores - 2) / 2) 1;
    in
    {
      max-jobs = lib.mkDefault nixJobs;
      cores = lib.mkDefault nixCores;

      download-buffer-size = 536870912;
      auto-optimise-store = true;

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
        "https://cache.${domain}/rgnet"
      ];
      trusted-substituters = [ "https://cache.${domain}/rgnet" ];

      trusted-public-keys = [
        "rgnet:KGvhLKw9yQzWbzy+/+KiTCFMqyOCxN12c0Cf/mk+dwE="
      ];

      # Fallback quickly if substituters are not available.
      connect-timeout = 1;

      # The default at 10 is rarely enough.
      log-lines = lib.mkDefault 30;

      # Avoid disk full issues.
      max-free = lib.mkDefault (3000 * 1024 * 1024);
      min-free = lib.mkDefault (512 * 1024 * 1024);

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;

      flake-registry = ""; # Disable global flake registry
      warn-dirty = false;
      use-xdg-base-directories = true;
    };

  nix.gc = lib.mkIf (!config.rg.isBuilder) {
    randomizedDelaySec = "45min";
    automatic = true;
    dates = "monthly";
    #Keep last 5 generations.
    options =
      let
        days = if config.rg.isBuilder then "120d" else "90d";
      in
      "--delete-older-than ${days}";
  };

  # Add nixpkgs input to NIX_PATH
  # This lets nix2 commands still use <nixpkgs>
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];

  nix.distributedBuilds = !config.rg.isBuilder && config.rg.class == "workstation";

  programs.ssh.extraConfig = lib.mkIf (!config.rg.isBuilder) ''
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

  nix.buildMachines = lib.mkIf (!config.rg.isBuilder && config.rg.class == "workstation") (

    let
      # nixbuild.net has 'kvm' feature, but in early-access and on request.
      feats = [
        "benchmark"
        "nixos-test"
        "big-parallel"
      ];

      nixbuildFun = system: {
        hostName = "eu.nixbuild.net";
        protocol = "ssh-ng";
        inherit system;
        maxJobs = 100;
        supportedFeatures = feats;
        speedFactor = 80;
        mandatoryFeatures = [ ];
      };
    in
    [
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

    ]
    ++ (map nixbuildFun [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ])
  );

  #TODO: disable heavy supported-features on non-builders (but locally, not remote builders!)
  # One nixbuild.net entry per 'system'.
}
