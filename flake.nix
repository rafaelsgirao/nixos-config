{
  nixConfig = {
    extra-substituters = [
      "https://cache.rsg.ovh/rgnet"
      "https://cosmic.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "rgnet:KGvhLKw9yQzWbzy+/+KiTCFMqyOCxN12c0Cf/mk+dwE="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };
  inputs = {
    #--------------
    #Important inputs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
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
        gitignore.follows = "gitignore";
      };
    };

    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
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

    # lan-mouse = {
    #   url = "github:feschber/lan-mouse";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.rust-overlay.follows = "rust-overlay";
    # };
    impermanence.url = "github:nix-community/impermanence/master";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs-stable.follows = "nixpkgs";
      # inputs.flake-compat.follows = "flake-compat";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # simple-nixos-mailserver = {
    #   url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nixpkgs-22_11.follows = "nixpkgs";
    #   inputs.nixpkgs-23_05.follows = "nixpkgs";
    #   inputs.utils.follows = "flake-utils";
    #   inputs.flake-compat.follows = "flake-utils";
    # };

    home = {
      url = "github:nix-community/home-manager/release-24.11";
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
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEwOBxayZyd/zGYyoTRN2rdIQM71nzVT3lISg2pNfrZRAAAABHNzaDo= Yubikey-U2F-Resident:"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7foe85vNDLm0vyVVugR8ThC1VjHuAtqAQ/K2AAVE9r rg@sazed[dec '24]"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID97/zlRwgxhnOyqHcawWjlL9XjbdmrWbYwayj1bG67I rg@vin[jan '25]"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb+ipW3JOFhud1apnnMH4Ycm95Br/Fz8/0b1SqaNO6s rg@adolin[mar '25]"
      ];

      secretsDir = self + "/secrets";

      # https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig
      nixpkgsConfig = {
        allowUnfree = true;
        # contentAddressedByDefault = true;
        warnUndeclaredOptions = true;

      };
      # Imports every host defined in a directory.
      mkHosts =
        dir:
        listToAttrs (
          map (name: {
            inherit name;
            value = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit
                  sshKeys
                  inputs
                  user
                  secretsDir
                  self
                  ;
                inherit (outputs) nixosConfigurations;
                hostSecretsDir = "${secretsDir}/${name}";
              };
              modules = [
                {
                  nixpkgs = {
                    overlays = builtins.attrValues outputs.overlays;
                    config = nixpkgsConfig;
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
                shopt -s expand_aliases

                if command -v nom &>/dev/null; then
                  alias nixbin='nom'
                else
                  alias nixbin='${pkgs.nix}/bin/nix'
                fi

                targets=()
                for host in $(${pkgs.nix}/bin/nix flake show --accept-flake-config --json --quiet --all-systems | jq -r '.nixosConfigurations | keys[]'); do
                    targets+=(".#nixosConfigurations.$host.config.system.build.toplevel")
                done

                # Print the final count of configurations
                echo "Building ''${#targets[@]} configurations"

                # Run nixbin build with all accumulated targets
                if [ ''${#targets[@]} -gt 0 ]; then
                    nixbin build --no-link --accept-flake-config "''${targets[@]}"
                fi




              '';
              buildAllPackages = pkgs.writeShellScriptBin "build-all-packages" ''
                set -euo pipefail
                for package in $(${pkgs.nix}/bin/nix flake show --accept-flake-config --json --quiet | jq '.packages."${system}" | keys[]' ); do
                  echo "Building package $package"
                  ${pkgs.nix}/bin/nix build --no-link  --accept-flake-config ".#packages.${system}.$package"
                done
              '';
              # TODO: add `<hostname>_build` apps as a shortcut to run `nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel $@`

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
          treefmt.projectRootFile = "./flake.nix";
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
            config = nixpkgsConfig;
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
                  config = nixpkgsConfig;
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
