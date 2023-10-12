{
  inputs = {
    #Important inputs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";

    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.05";
      inputs.nixpkgs-23_05.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-utils";
    };
    home = {
      url = "github:nix-community/home-manager/release-23.05";
      # url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not using flake-compat directly, but useful to get the other inputs to follow this
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    bolsas-scraper =
      {
        url = "github:ist-bot-team/bolsas-scraper";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    sirpt-feed =
      {
        url = "git+ssh://git@git.spy.rafael.ovh:4222/rg/sirpt-feed.git";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home";
      };
    };
    trackerslist = {
      url = "github:ngosang/trackerslist";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote?ref=v0.3.0";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };

    # microvm = {
    #     url = "github:astro/microvm.nix";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    #Important for checks flake output.
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-compat.follows = "flake-compat";
    };
    impermanence.url = "github:nix-community/impermanence/master";
    dsi-setupsecrets = {
      url = "git+ssh://git@git.spy.rafael.ovh:4222/mirrors/setup-secrets.git";
      flake = false;
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:

    let
      inherit (builtins) attrNames readDir listToAttrs;
      inherit (inputs.nixpkgs) lib;
      inherit (lib) mapAttrsToList;

      user = "rg";

      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTJmVou9C3Q5hZ48FcCv3UoTrG5m2QAf26V8RxZfwxB rg@medic@NixOS"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a rg@Scout"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNh9R6uSjnGxHwxul87AcXs4mzEMSOcjubmuMzO/OkQ demo"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPPsEKHGmtdhA+uqziPEGnJirEXfFQdqCDyIFJ2z1MKgAAAABHNzaDo= Yubikey-U2F"
      ];
      system = "x86_64-linux";

      pkgs-sets = final: _prev:
        let
          args = {
            inherit (final) system;
            # config.allowUnfree = true;
            config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
              # "osu-lazer"
              # "flashplayer"
              "vscode"
              "code"
              # "cnijfilter2" # canon printer
              # "font-bh-lucidatypewriter-75dpi" # https://github.com/NixOS/nixpkgs/issues/99014
              "steam-run"
              "intel-ocl"
              "steam-original"
              "anydesk"
              "burpsuite"
              "nvidia-x11"
              # "corefonts"
            ];
            # config.contentAddressedByDefault = true;
          };
        in
        {
          unstable = import inputs.nixpkgs-unstable args;
          old = import inputs.nixpkgs-old args;
          # latest = import inputs.nixpkgs-latest args;
        };

      secretsDir = self + "/secrets";
      overlaysDir = ./overlays;

      myOverlays = mapAttrsToList
        (name: _: import "${overlaysDir}/${name}" { inherit inputs; inherit self; })
        (readDir overlaysDir);

      overlays = [
        # inputs.swayfx.overlays.default
        pkgs-sets
      ] ++ myOverlays;

      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          # "osu-lazer"
          # "flashplayer"
          "code"
          "vscode"
          "vscode-fhs"
          # "cnijfilter2" # canon printer
          # "font-bh-lucidatypewriter-75dpi" # https://github.com/NixOS/nixpkgs/issues/99014
          "steam-run"
          "intel-ocl"
          "steam-original"
          "anydesk"
          "burpsuite"
          "nvidia-x11"
          # "corefonts"
        ];
        # config.contentAddressedByDefault = true;
        # config.allowUnfree = true;
      };

      # Imports every host defined in a directory.
      mkHosts = dir:
        listToAttrs (map
          (name: {
            inherit name;
            value = inputs.nixpkgs.lib.nixosSystem {
              inherit system pkgs;
              specialArgs = {
                inherit sshKeys;
                inherit inputs;
                inherit user;
                inherit secretsDir;
                hostSecretsDir = "${secretsDir}/${name}";
              };
              modules = [
                { networking.hostName = name; }
                ./modules/core.nix
                ./modules/hardware.nix
                ./modules/home.nix
                inputs.simple-nixos-mailserver.nixosModule
                inputs.agenix.nixosModules.default
                inputs.lanzaboote.nixosModules.lanzaboote
                inputs.home.nixosModules.home-manager
                inputs.disko.nixosModules.disko
                (dir + "/${name}/hardware.nix")
                (dir + "/${name}/machine.nix")
                # inputs.microvm.nixosModules.microvm
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = { hostName = name; };
                    # users.${user} = import (dir + "/${name}/home.nix");
                    # users.${user} = import ./modules/home.nix;
                  };
                }
                # ( inputs.impermanence + "/home-manager.nix" )
                inputs.impermanence.nixosModules.impermanence
              ];
            };
          })
          (attrNames (readDir dir)));

    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          inputs.pre-commit-hooks-nix.flakeModule
        ];
        systems = [
          # systems for which you want to build the `perSystem` attributes
          "x86_64-linux"
        ];
        # for reference: perSystem = { config, self', inputs', pkgs, system, ... }: {
        perSystem = { config, pkgs, ... }: {
          devShells.default = config.pre-commit.devShell;
          pre-commit.settings.hooks = {
            nixpkgs-fmt.enable = true;
            statix.enable = true;
            deadnix = {
              enable = true;
            };

            gitleaks = {
              enable = true;
              name = "gitleaks";
              description = "Prevents commiting secrets";
              entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
              pass_filenames = false;
            };


          };
          pre-commit.settings.settings = {
            deadnix.edit = true;
          };
        };
        flake = {
          nixosConfigurations = mkHosts ./hosts;

          deploy.nodes =
            let
              deploy-rs-activate = inputs.deploy-rs.lib.x86_64-linux.activate.nixos;

            in
            {
              scout = {
                sshUser = "root";
                hostname = "192.168.10.1";
                profiles.system.path =
                  deploy-rs-activate self.nixosConfigurations.scout;
              };
              engie = {
                sshUser = "root";
                hostname = "192.168.10.3";
                profiles.system.path =
                  deploy-rs-activate self.nixosConfigurations.engie;
              };
              spy = {
                sshUser = "root";
                hostname = "192.168.10.6";
                profiles.system.path =
                  deploy-rs-activate self.nixosConfigurations.spy;
              };
              # sniper = {
              #   sshUser = "root";
              #   hostname = "192.168.10.8";
              #   profiles.system.path =
              #     deploy-rs-activate self.nixosConfigurations.sniper;
              # };
              medic = {
                sshUser = "root";
                hostname = "192.168.10.5";
                profiles.system.path =
                  deploy-rs-activate self.nixosConfigurations.medic;
              };
            };
          # This is highly advised, and will prevent many possible mistakes
          checks = builtins.mapAttrs
            (_system: deployLib: deployLib.deployChecks self.deploy)
            inputs.deploy-rs.lib;
        };

      };
}
