{
  nixConfig = {
    extra-substituters = [ "https://cache.rafael.ovh/rgnet" ];
    extra-trusted-public-keys = [ "rgnet:q980JJH0BwxSKeu0mfn40xc6wTMF76/PZpZv1XAZGXs=" ];
    flake-registry = [ "https://rafael.ovh/flake-registry.json" ];
  };
  inputs = {
    #--------------
    #Important inputs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #---------------

    #--------------------
    #Inputs that other inputs depend on.
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #-------------------

    # -----------------------
    # Utilities.
    nixinate = {
      # url = "github:matthewcroughan/nixinate";
      url = "github:rafaelsgirao/nixinate";
      # url = "git+file:///home/rg/Documents/repos/nixinate";
      # url = "path:///home/rg/Documents/repos/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        gitignore.follows = "gitignore";
      };
    };

    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs = {
        #FIXME: make PR so that these lines can be uncommented
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home";
        flake-parts.follows = "flake-parts";
        nix-darwin.follows = "";
        #        devshell.follows = "";
        #        git-hooks.follows = "";
        flake-compat.follows = "flake-compat";
        #        treefmt-nix.follows = "";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # ------------------------

    # ----------------------
    # Inputs that add notable features.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
      inputs.crane.follows = "crane";
    };

    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    impermanence.url = "github:nix-community/impermanence/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    # simple-nixos-mailserver = {
    #   url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nixpkgs-22_11.follows = "nixpkgs";
    #   inputs.nixpkgs-23_05.follows = "nixpkgs";
    #   inputs.utils.follows = "flake-utils";
    #   inputs.flake-compat.follows = "flake-utils";
    # };

    home = {
      url = "github:nix-community/home-manager/release-24.05";
      # url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bolsas-scraper = {
      url = "github:ist-bot-team/bolsas-scraper";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    wc-bot = {
      # url = "github:ist-chan-bot-team/ist-chan-bot";
      url = "git+ssh://git@github.com/ist-chan-bot-team/ist-chan-bot.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        pre-commit-hooks-nix.follows = "";
        treefmt-nix.follows = "";
      };
    };

    # ist-discord-bot = {
    #   url = "github:ist-bot-team/ist-discord-bot/rg/make-nix-package";
    #   # url = "github:nix-community/home-manager/master";
    #   # inputs.nixpkgs.follows = "nixpkgs"; WARNING: test right after uncommenting this, if you do.
    # };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home";
        darwin.follows = ""; # If in the future I get a Mac (unlikely), remove this line.
      };
    };
    #Not pinning to 0.3.0 anymore because master allows me to cancel the 'pre-commit-hooks-nix' input.
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "";
      inputs.crane.follows = "crane";
      inputs.rust-overlay.follows = "rust-overlay";
    };

  };

  outputs =
    inputs@{ self, ... }:

    let
      inherit (self) outputs;
      inherit (builtins) attrNames readDir listToAttrs;
      lib =
        inputs.nixpkgs.lib
        // inputs.flake-parts.lib
        // (inputs.nixpkgs.lib.optionalAttrs (inputs.home ? lib) inputs.home.lib);
      inherit (lib) mapAttrs;
      fs = lib.fileset;

      user = "rg";

      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a rg@Scout"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNh9R6uSjnGxHwxul87AcXs4mzEMSOcjubmuMzO/OkQ demo"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEwOBxayZyd/zGYyoTRN2rdIQM71nzVT3lISg2pNfrZRAAAABHNzaDo= Yubikey-U2F-Resident:"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJvkSRd4B8oEvmXI5uduJtrV4GkRc/f1PFaezQ3wobn08apvaTGHLrNPqgqzv+QwNppWkwSX0j2fNqt2dsUmcbw= rg@sazed2[TPM]"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBxyt2Uhru+PIf9SKRF96AW05P9WuyR7NKbS6OZyElNjOT+1qmkeL82+7B5qeHsACA3ZRo4svorIS1Q8khLmexk= rg@vin-TPM"
      ];

      secretsDir = self + "/secrets";

      # Imports every host defined in a directory.
      mkHosts =
        dir:
        listToAttrs (
          map (name: {
            inherit name;
            value = inputs.nixpkgs.lib.nixosSystem rec {
              specialArgs = {
                inherit sshKeys;
                inherit inputs;
                inherit user;
                inherit secretsDir;
                inherit (outputs) nixosConfigurations;
                inherit self;
                hostSecretsDir = "${secretsDir}/${name}";
              };
              modules = [
                {
                  nixpkgs = {
                    overlays = builtins.attrValues outputs.overlays;
                    config = {
                      allowUnfree = true;
                      # contentAddressedByDefault = true;
                    };
                  };
                }
                { networking.hostName = name; }
                ./modules/core/default.nix
                ./modules/core/options.nix
                ./modules/core/home.nix
                ./modules/hardware/default.nix
                # inputs.simple-nixos-mailserver.nixosModule
                inputs.nixinate.nixosModule
                inputs.agenix.nixosModules.default
                inputs.home.nixosModules.home-manager
                inputs.disko.nixosModules.disko
                inputs.nixos-cosmic.nixosModules.default

                (dir + "/${name}/hardware.nix")
                (dir + "/${name}/machine.nix")
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = {
                      hostName = name;
                    };
                    # users.${user} = import (dir + "/${name}/home.nix");
                    # users.${user} = import ./modules/home.nix;
                  };
                }
                # ( inputs.impermanence + "/home-manager.nix" )
                inputs.impermanence.nixosModules.impermanence
              ];
            };
          }) (attrNames (readDir dir))
        );

    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
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
      perSystem =
        {
          config,
          pkgs,
          inputs',
          system,
          ...
        }:
        {
          apps =
            let
              buildAllHosts = pkgs.writeShellScriptBin "build-all-configs" ''
                set -euo pipefail
                for host in $(${pkgs.nix}/bin/nix flake show --accept-flake-config --json --quiet --all-systems | jq '.nixosConfigurations | keys[]' ); do
                  echo "Building configuration for $host"
                  ${pkgs.nix}/bin/nix build --no-link  --accept-flake-config ".#nixosConfigurations.$host.config.system.build.toplevel"
                done
              '';
              buildAllPackages = pkgs.writeShellScriptBin "build-all-packages" ''
                set -euo pipefail
                for package in $(${pkgs.nix}/bin/nix flake show --accept-flake-config --json --quiet | jq '.packages."${system}" | keys[]' ); do
                  echo "Building package $package"
                  ${pkgs.nix}/bin/nix build --no-link  --accept-flake-config ".#packages.${system}.$package"
                done
              '';

            in
            {
              build-all-hosts = {
                type = "app";
                program = buildAllHosts;
              };
              build-all-packages = {
                type = "app";
                program = buildAllPackages;
              };
            };
          #TODO: would be cooler if the flake exposed something that could be used by 'nix profile install github:<...>'
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              ripgrep
              fd
              curl
              git
              fish
              tmux
              gitui
              htop
              age-plugin-yubikey
            ];
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
          };
          treefmt.projectRootFile = ./flake.nix;
          treefmt.programs = {
            nixfmt.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            mdformat.enable = true;
            deadnix.enable = true;
            ruff-check.enable = true;
            ruff-format.enable = true;
            statix.enable = true;
            statix.disabled-lints = [ "repeated_keys" ];

          };
          packages = import ./packages {
            inherit pkgs;
            inherit inputs;
            inherit inputs';
          };
          _module.args.debug = true;
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ outputs.overlays.pkgs-sets-unstable ];
            # config = { contentAddressedByDefault = true; };
          };
        };

      flake = {
        #So nix repl can access `self`, through outputs.self
        inherit self lib;

        nixosConfigurations = mkHosts ./hosts;
        overlays =
          let
            # https://nix.dev/tutorials/working-with-local-files.html
            sourceFiles = fs.unions [ (fs.fileFilter (file: file.hasExt "nix") ./overlays) ];
            overlaysDir = fs.toSource {
              root = ./overlays;
              fileset = sourceFiles;
            };

            myOverlays =
              mapAttrs
                # Can't use overlaysDir here because I want to access non-overlay files in overlays dir
                # And `overlaysDir` doesn't have them
                (name: _: import ./overlays/${name} { inherit inputs; })
                (readDir overlaysDir);

          in
          {

            pkgs-sets-unstable =
              final: _prev:
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
            pkgs-sets-mypkgs = final: _prev: { mypkgs = outputs.packages.${final.system}; };
            pkgs-sets-everythingmusl = final: prev: { final = prev.pkgsMusl; };
          }
          // myOverlays;

        homeConfigurations = mapAttrs (
          _: host: host.config.home-manager.users."rg".home
        ) outputs.nixosConfigurations;
      };
    };
}
