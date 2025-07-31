{
  config,
  pkgs,
  lib,
  secretsDir,
  inputs,
  file,
  ...
}:
let
  isWorkstation = config.rg.class == "workstation";
  isVirt = config.rg.machineType == "virt";
  config' = config;
  inherit (config.networking) domain;
  inherit (config.rg) isBuilder;
in
{

  age.secrets = {

    ssh-config = lib.mkIf isWorkstation {
      file = "${secretsDir}/SSH-config.age";
      owner = "rg";
    };
    attic-builder-config = lib.mkIf isBuilder {
      file = "${secretsDir}/attic-config-builder.age";
      mode = "400";
      owner = "rg";
    };
  };

  environment.systemPackages = lib.mkIf isBuilder (
    with pkgs;
    [
      attic-client
    ]
  );

  environment.persistence."/pst".users.rg.directories = lib.optionals isWorkstation [
    ".ssh"
    ".local/share/atuin"
    ".local/share/keyrings"
    ".local/share/zoxide"
    ".local/share/direnv"
    ".local/share/nix"
  ];
  environment.persistence."/state".users.rg.directories = lib.optionals (!isWorkstation) [
    ".local/share/atuin"
    ".local/share/zoxide"
  ];
  hm =
    { config, ... }:
    let
      hmLib = config.lib;
    in

    {
      imports = [
        (inputs.impermanence + "/home-manager.nix")
        inputs.nixvim.homeManagerModules.nixvim
      ];

      home.homeDirectory = "/home/rg";
      home.username = "rg";
      news.display = "show";

      home.packages = with pkgs; [
        mypkgs.randomport
        mypkgs.python-scripts
      ];

      programs.tmux = {
        enable = true;
        clock24 = true;
        historyLimit = 20000;
        mouse = true;
        extraConfig = ''
          # Allows searching stdout buffer with `Ctrl /`
          bind-key / copy-mode \; send-keys C-S
          bind b set-window-option synchronize-panes
        '';
      };

      home.preferXdgDirectories = true;
      xdg.enable = true;
      home.enableNixpkgsReleaseCheck = true;
      #Sway files
      home.file =
        { }
        // lib.optionalAttrs isWorkstation {
          ".config/fish/fish_history".source =
            hmLib.file.mkOutOfStoreSymlink "/state/home/rg/.config/fish/fish_history";
          ".config/mimeapps.list".source =
            hmLib.file.mkOutOfStoreSymlink "/state/home/rg/.config/mimeapps.list";

          # "Although deprecated, several applications still read/write to ~/.local/share/applications/mimeapps.list."
          # "To simplify maintenance, simply symlink it to ~/.config/mimeapps.list:"
          # ^ https://wiki.archlinux.org/title/XDG_MIME_Applications#mimeapps.list
          ".local/share/applications/mimeapps.list".source =
            hmLib.file.mkOutOfStoreSymlink "/home/rg/.config/mimeapps.list";
        }
        // lib.optionalAttrs isBuilder {

          ".config/attic/config.toml".source =
            hmLib.file.mkOutOfStoreSymlink "${config'.age.secrets.attic-builder-config.path}";
        };

      programs.ssh = {
        enable = true;
        controlMaster = "auto";
        controlPersist = "10m";
        extraConfig = lib.mkIf isWorkstation ''
          AddKeysToAgent yes
          Include ${config'.age.secrets.ssh-config.path}
        '';
      };

      programs.eza = {
        enable = true;
        enableFishIntegration = true;
        git = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
        icons = "auto";
      };

      programs.git = {
        enable = true;
        aliases = {
          log = "log --show-signature";
          g = "log --all --graph --decorate --show-signature";
          graph = "log --all --graph --decorate --show-signature";
          s = "status";
          d = "diff";
        };
        delta.enable = true;
        lfs.enable = true;
        userEmail = lib.mkDefault "git@rafael.ovh";
        userName = "Rafael Girão";

        ignores = [
          "*~"
          "*.swp"

        ];
        extraConfig = {
          core = {
            editor = "nvim";
            whitespace = "warn";

          };
          blame = {
            ignoreRevsFile = ".git-blame-ignore-revs";
          };

          pull = {
            rebase = true;
          };
          delta = {
            navigate = true;
          };

          url = {
            "git@github.com:".insteadOf = "https://github.com/";
            "git@git.${domain}:2222".insteadOf = "https://git.${domain}/";
          };

          # SSH commit signing. See:
          # https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html
          gpg.ssh.allowedSignersFile = "${./../../files/allowed_signers}";

          commit.gpgSign = lib.mkIf isWorkstation true;
          gpg.format = "ssh";
          user = lib.mkIf isWorkstation {
            #`man ssh-keygen` reads:
            # -Y sign:
            #  The key used for signing is specified using the -f option and may refer to either a private key,
            #  or a public key with the private half available via ssh-agent(1).
            signingkey = "/home/rg/.ssh/id_gitsign.pub";
          };
        };
      };

      # Thanks =^)
      # https://github.com/Pesteves2002/dotfiles/tree/nixos/profiles/nixvim
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        colorscheme = "catppuccin-macchiato";
        colorschemes.catppuccin = {
          enable = true;
          settings = {
            flavour = "macchiato";
          };
        };

        viAlias = true;
        vimAlias = true;
        plugins = lib.mkIf isWorkstation {
          #Fully featured file explorer.
          chadtree.enable = true;
          #"Fast AF completion".
          coq-nvim.enable = true;
          #Status bar on the bottom.
          lualine.enable = true;
          # Easy commenting
          comment.enable = true;
          #Show errors in-line.
          trouble.enable = true;
          # In-line git blame.
          gitsigns.enable = true;
          # Auto add closing brackets, parentheses, etc.
          nvim-autopairs.enable = true;
          # Rust
          rustaceanvim.enable = true;
          # Dependency of chadtree and trouble
          web-devicons.enable = true;
          #Language Server Providers.
          lsp.enable = true;
          lsp.servers = {
            nil_ls.enable = true; # Nix
            marksman.enable = true; # Markdown

            # Python
            ruff.enable = true;
            # pylyzer crashes ALL the time, very annoying
            # pylyzer.enable = true;
            pylsp.enable = true;
            # pyre.enable = true; # TODO: pyre.package not defined?

            ts_ls.enable = true; # Typescript
            terraformls.enable = true; # Terraform
          };
        };
        extraConfigVim = ''
          syntax on
          set ruler
          set number
          let no_buffers_menu=1
          set smartcase
          set ignorecase
          set incsearch
          set tabstop=4
          set softtabstop=4
          set shiftwidth=4
          set mouse=
          set expandtab
        '';
      };

      programs.fish = {
        enable = true;
        shellAbbrs = {
          cd = "z";
          cat = "bat";
          ip = "ip -c";
          vim = "nvim";
          rm = "rip";
          jfu = "journalctl -fu";
          gcm = "git commit -m \"";
          gcmn = "git commit --no-gpg-sign -m \"";
          jf = "journalctl -f";
          dc = "docker-compose";
          fd = "fd -HI";
          cpugov = "cpupower frequency-set -g";
          # "sudo-" = "sudoedit";
          se = "sudoedit";
          "_" = "sudo";
        };
        plugins = with pkgs.fishPlugins; [
          {
            name = "done";
            inherit (done) src;
          }
          {
            name = "bass";
            inherit (bass) src;
          }
        ];
        shellAliases = rec {
          rg = "rg -i --hidden";
          tree = "eza -T";
          zathura = "zathura --fork";
          nix-shell = "nix-shell --command 'fish'";
          ssh = "TERM=xterm-256color ${pkgs.openssh}/bin/ssh";
        };
        functions = {
          sudoedit = ''
            set -lx SUDO_COMMAND "sudoedit $argv";
            command sudoedit $argv;
          '';
        };
        interactiveShellInit = ''
          set fish_greeting #Disables "Welcome to fish! message"

        '';
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        MANROFFOPT = "-c";
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        NIXOS_OZONE_WL = "1";
      };

      programs.atuin = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        package = pkgs.atuin;
        flags = [ "--disable-up-arrow" ];
        settings = {
          dialect = "uk";
          auto_sync = false;
          update_check = false;
          # Using a daemon works around timeout issues when using ZFS.
          # https://github.com/atuinsh/atuin/issues/952
          # Requires atuin >= 18.3.0 (which is why package is in unstable ATM)
          daemon = {
            enabled = true;
            # TODO: ugly hardcoded path!
            socket_path = "/run/user/1000/atuin.sock";
          };
          sync = {
            records = true;
          };
          # sync_frequency = "24h";
          # sync_address = lib.mkIf isWorkstation "https://atuin.spy.rafael.ovh";
        };
      };

      # https://github.com/atuinsh/atuin/pull/2172/files
      systemd.user.services.atuin-daemon = {

        Unit = {
          Description = "atuin shell history daemon";
          Requires = [ "atuin-daemon.socket" ];
        };

        Service = {
          # Environment = "'SSH_AUTH_SOCK=%t/${socket}'";
          ExecStart = "${pkgs.unstable.atuin}/bin/atuin daemon";
          # Type = "simple";
        };
        Install = {
          WantedBy = [ "default.target" ];
          Also = [ "atuin-daemon.socket" ];
        };
      };

      systemd.user.sockets."atuin-daemon" = {
        Unit = {
          Description = "Unix socket activation for atuin shell history daemon";
        };
        Socket = {
          ListenStream = "%t/atuin.socket";
          SocketMode = "0600";
          # Service = "ssh-tpm-agent.service"; :thinking:
        };
        Install = {
          WantedBy = [ "sockets.target" ];
        };

      };
      programs.starship = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        settings = {
          add_newline = false;
          hostname.ssh_only = true;
          package.disabled = true;
        };
      };

      programs.zoxide = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
      };

      programs.gitui = {
        enable = true;
        # https://github.com/mcatppuccin/gitui/blob/main/themes/catppuccin-macchiato.ron
        theme = ''
          (
              selected_tab: Some("Reset"),
              command_fg: Some("#cad3f5"),
              selection_bg: Some("#5b6078"),
              selection_fg: Some("#cad3f5"),
              cmdbar_bg: Some("#1e2030"),
              cmdbar_extra_lines_bg: Some("#1e2030"),
              disabled_fg: Some("#8087a2"),
              diff_line_add: Some("#a6da95"),
              diff_line_delete: Some("#ed8796"),
              diff_file_added: Some("#a6da95"),
              diff_file_removed: Some("#ee99a0"),
              diff_file_moved: Some("#c6a0f6"),
              diff_file_modified: Some("#f5a97f"),
              commit_hash: Some("#b7bdf8"),
              commit_time: Some("#b8c0e0"),
              commit_author: Some("#7dc4e4"),
              danger_fg: Some("#ed8796"),
              push_gauge_bg: Some("#8aadf4"),
              push_gauge_fg: Some("#24273a"),
              tag_fg: Some("#f4dbd6"),
              branch_fg: Some("#8bd5ca")
          )
        '';
      };
      programs.htop = {
        enable = true;
        package = pkgs.htop-vim;
        settings = {
          show_program_path = 0;
          shadow_other_users = 1;
          hide_kernel_threads = 1;
          hide_userland_threads = 1;
        }
        // lib.optionalAttrs (!isVirt) {
          show_cpu_frequency = 1;
          show_cpu_temperature = 1;
        };
      };
      programs.direnv = lib.mkIf isWorkstation {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
