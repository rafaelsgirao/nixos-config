{ config, pkgs, lib, inputs, ... }: {

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  programs.ssh.extraConfig = lib.mkIf (!config.rg.isBuilder) ''
    Host spybuilder
      HostName 192.168.10.6
      Port 22
      User root
      # IdentitiesOnly yes
      # IdentityFile /root/.ssh/id_builder
  '';

  nix = {

    #Enable use of Flakes.
    package = pkgs.nixFlakes;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      # Enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];

      allowed-users = [ "@wheel" ];
      trusted-users = [ "rg" "root" ];

      # Fallback quickly if substituters are not available.
      connect-timeout = 5;

      # The default at 10 is rarely enough.
      log-lines = lib.mkDefault 30;

      # Avoid disk full issues
      max-free = lib.mkDefault (3000 * 1024 * 1024);
      min-free = lib.mkDefault (512 * 1024 * 1024);

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;
      flake-registry = "";
      #Automatically saves up space in nix-store by hardlinking
      #files with identical content
      #This is apparently a costly operation in HDDs, so only enabled per-machine
      #  nix.settings.auto-optimise-store = false;
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];

    #Security implications if true
    #... but with nix.settings.sandbox requires it....
    # security.allowUserNamespaces = lib.mkForce false;

    distributedBuilds = !config.rg.isBuilder;

    buildMachines = lib.mkIf (!config.rg.isBuilder) [{
      sshUser = "root";
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
  };

}
