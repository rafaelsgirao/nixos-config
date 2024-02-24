{
  nixConfig = {
    extra-substituters = [
      "https://cache.spy.rafael.ovh"
    ];
    extra-trusted-public-keys = [
      "cache.spy.rafael.ovh:5aGgIOEo7H004XtJq5Bob59PiISlNCNH+m0v4IVyyCA="
    ];
    flake-registry = [
      "https://rafael.ovh/flake-registry.json"
    ];
  };
  inputs = {
    #--------------
    #Important inputs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #---------------

    #--------------------
    #Inputs that other inputs depend on

    # Not using flake-compat directly, but useful to get the other inputs to follow this
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    #-------------------


    # -----------------------
    # Utilities.
    nixinate = {
      # url = "github:matthewcroughan/nixinate";
      url = "github:rafaelsgirao/nixinate?ref=feat/test-2";
      # url = "git+file:///home/rg/repos/Self/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks-nix =
      {
        url = "github:cachix/pre-commit-hooks.nix";

        inputs = {
          flake-utils.follows = "flake-utils";
          flake-compat.follows = "flake-compat";
          nixpkgs.follows = "nixpkgs";
          nixpkgs-stable.follows = "nixpkgs";
        };
      };

    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # ------------------------


    # ----------------------
    # Inputs that add notable features.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence/master";

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-22_11.follows = "nixpkgs";
      inputs.nixpkgs-23_05.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-utils";
    };

    home = {
      url = "github:nix-community/home-manager/release-23.11";
      # url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bolsas-scraper =
      {
        url = "github:ist-bot-team/bolsas-scraper";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs = {
          flake-parts.follows = "flake-parts";
        };
      };
    wc-bot =
      {
        # url = "github:ist-chan-bot-team/ist-chan-bot";
        # url = "git+ssh://git@github.com/ist-chan-bot-team/ist-chan-bot.git";
        url = "git+ssh://git@git.spy.rafael.ovh:4222/rg/ist-chan-bot.git";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs = {
          flake-parts.follows = "flake-parts";
        };
      };
    ist-discord-bot = {
      url = "github:ist-bot-team/ist-discord-bot/rg/make-nix-package";
      # url = "github:nix-community/home-manager/master";
      # inputs.nixpkgs.follows = "nixpkgs"; WARNING: test right after uncommenting this, if you do.
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote?ref=v0.3.0";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks-nix";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:

    let
      inherit (self) outputs;
      inherit (builtins) attrNames readDir listToAttrs;
      # inherit (inputs.nixpkgs) lib;
      lib = inputs.nixpkgs.lib // inputs.flake-parts.lib // inputs.home.lib;
      inherit (lib) mapAttrs;

      user = "rg";

      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a rg@Scout"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNh9R6uSjnGxHwxul87AcXs4mzEMSOcjubmuMzO/OkQ demo"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPPsEKHGmtdhA+uqziPEGnJirEXfFQdqCDyIFJ2z1MKgAAAABHNzaDo= Yubikey-U2F"
      ];

      secretsDir = self + "/secrets";

      # Imports every host defined in a directory.
      mkHosts = dir:
        listToAttrs (map
          (name: {
            inherit name;
            value = inputs.nixpkgs.lib.nixosSystem rec {
              specialArgs = {
                inherit sshKeys;
                inherit inputs;
                inherit user;
                inherit secretsDir;
                inherit (outputs) nixosConfigurations;
                hostSecretsDir = "${secretsDir}/${name}";
              };
              modules = [
                {
                  nixpkgs = {
                    overlays = builtins.attrValues outputs.overlays;
                    config = {
                      allowUnfree = true;
                    };
                  };
                }
                { networking.hostName = name; }
                ./modules/core/default.nix
                ./modules/core/options.nix
                ./modules/core/home.nix
                ./modules/hardware/default.nix
                inputs.simple-nixos-mailserver.nixosModule
                inputs.nixinate.nixosModule
                inputs.agenix.nixosModules.default
                inputs.lanzaboote.nixosModules.lanzaboote
                inputs.home.nixosModules.home-manager
                inputs.disko.nixosModules.disko
                (dir + "/${name}/hardware.nix")
                (dir + "/${name}/machine.nix")
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
          inputs.treefmt-nix.flakeModule
          inputs.nixinate.flakeModule
        ];
        systems = [
          # systems for which you want to build the `perSystem` attributes
          "x86_64-linux"
          "aarch64-linux"
        ];
        # for reference: perSystem = { config, self', inputs', pkgs, system, ... }: {
        perSystem = { config, pkgs, inputs', system, ... }: {
          apps =
            let
              buildAllConfigs = pkgs.writeShellScriptBin "build-all-configs" ''
                for host in $(${pkgs.nix}/bin/nix flake show --accept-flake-config --json --quiet --all-systems | jq '.nixosConfigurations | keys[]' ); do
                  echo "Building configuration for $host"
                  ${pkgs.nix}/bin/nix build --no-link  --accept-flake-config ".#nixosConfigurations.$host.config.system.build.toplevel"
                done
              '';

            in
            {
              build-all = {
                type = "app";
                program = buildAllConfigs;
              };
            };
          devShells.default = pkgs.mkShell {
            shellHook = '' 
            # export DEBUG=1
            ${config.pre-commit.installationScript}
       '';
          };
          pre-commit.settings.hooks = {
            treefmt.enable = true;
            gitleaks = {
              enable = true;
              name = "gitleaks";
              description = "Prevents commiting secrets";
              entry = "${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact --staged";
              pass_filenames = false;
            };
            # commitizen = {
            #   enable = true;
            #   description = "Check whether the current commit message follows commiting rules. Allow empty commit messages by default, because they typically indicate to Git that the commit should be aborted.";
            #   entry = "${pkgs.commitizen}/bin/cz check --allow-abort --commit-msg-file";
            #   stages = [ "commit-msg" ];

            #   # pass_filenames = false;
            # };
          };
          treefmt.projectRootFile = ./flake.nix;
          treefmt.programs = {
            nixpkgs-fmt.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            mdformat.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            statix.disabled-lints = [
              "repeated_keys"
            ];

          };
          packages = import ./packages { inherit pkgs; inherit inputs; inherit inputs'; };
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              outputs.overlays.pkgs-sets-unstable
            ];
            config = { };
          };
        };

        flake = {

          nixosConfigurations = mkHosts ./hosts;
          overlays =
            let
              overlaysDir = ./overlays;
              # Thanks Borges
              myOverlays = mapAttrs
                (name: _: import "${overlaysDir}/${name}" { inherit inputs; })
                (readDir overlaysDir);
            in
            {

              pkgs-sets-unstable = final: _prev:
                let
                  args = {
                    inherit (final) system;
                    config.allowUnfree = true;
                    # config.contentAddressedByDefault = true;
                  };
                in
                {
                  unstable = import inputs.nixpkgs-unstable args;
                };
              pkgs-sets-mypkgs = final: _prev:
                {
                  mypkgs = outputs.packages.${final.system};
                };
            } // myOverlays;
          homeConfigurations = {
            scout = outputs.nixosConfigurations.tempest.config.home-manager.users."rg".home;
          };
        };
      };
}

