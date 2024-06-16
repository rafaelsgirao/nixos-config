{ config, pkgs, lib, hostSecretsDir, inputs, file, ... }:
let
  isWorkstation = config.rg.class == "workstation";
  config' = config;
in
{

  age.secrets.ssh-config = lib.mkIf isWorkstation {
    file = "${hostSecretsDir}/../SSH-config.age";
    owner = "rg";
  };

  environment.persistence."/pst".users.rg = {
    directories = lib.optionals isWorkstation [
      ".ssh"
      ".local/share/atuin"
      ".local/share/keyrings"
      ".local/share/zoxide"
      ".local/share/direnv"
    ];
  };
  environment.persistence."/state".users.rg.directories = lib.optionals (!isWorkstation) [
    ".local/share/atuin"
    ".local/share/zoxide"
  ];
  hm = { config, ... }: {
    imports = [
      (inputs.impermanence + "/home-manager.nix")
      inputs.nixvim.homeManagerModules.nixvim
    ];

    home.homeDirectory = "/home/rg";
    home.username = "rg";

    news.display = "show";

    programs.tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 20000;
      mouse = true;
    };

    xdg.enable = true;
    home.enableNixpkgsReleaseCheck = true;
    #Sway files
    home.file = {
      #Ugly but idc atm
      ".local/bin/portcheck".source = pkgs.copyPathToStore ../../files/portcheck;
      ".local/bin/randomport".source = pkgs.copyPathToStore ../../files/randomport;
    } // lib.optionalAttrs isWorkstation {
      ".config/fish/fish_history".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.config/fish/fish_history";
      ".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.config/mimeapps.list";
      ".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.config/Code/User/settings.json";
      ".local/share/nix/trusted-settings.json".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.local/share/nix/trusted-settings.json";
    };

    programs.ssh =
      {
        enable = true;
        controlMaster = "auto";
        controlPersist = "10m";
        extraConfig = lib.mkIf isWorkstation
          ''
            AddKeysToAgent yes
            Include ${config'.age.secrets.ssh-config.path}
          '';
      };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      git = true; #23.05
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      icons = true;
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

        pull = {
          rebase = true;
        };
        delta = {
          navigate = true;
        };

        url = {
          "git@github.com:".insteadOf = "https://github.com/";
          "git@git.spy.rafael.ovh:2222".insteadOf = "https://git.spy.rafael.ovh/";
        };

        # "gpg \"ssh\"".allowedSignersFile = pkgs.writeText "allowed_signers" ''
        #   git@rafael.ovh ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a rg@Scout
        #   git@rafael.ovh sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPPsEKHGmtdhA+uqziPEGnJirEXfFQdqCDyIFJ2z1MKgAAAABHNzaDo= Yubikey-SSH
        #   git@rafael.ovh sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPjOSq2fWLz3AyieIcFPYl5jYVvD1G/L35XkPcEKkPXCAAAAEnNzaDpZSy1naXQtc2lnbmluZw== Yubikey-Signing
        #   rafael.s.girao@tecnico.ulisboa.pt ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a rg@Scout
        #   rafael.s.girao@tecnico.ulisboa.pt sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPPsEKHGmtdhA+uqziPEGnJirEXfFQdqCDyIFJ2z1MKgAAAABHNzaDo= Yubikey-SSH
        #   rafael.s.girao@tecnico.ulisboa.pt sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPjOSq2fWLz3AyieIcFPYl5jYVvD1G/L35XkPcEKkPXCAAAAEnNzaDpZSy1naXQtc2lnbmluZw== Yubikey-Signing
        # '';
      };
      #     # SSH commit signing
      #     commit.gpgSign = true;
      #     gpg.format = "ssh";
      #     user = {
      #       signingkey = "/home/rg/.ssh/id_ed25519_sk"; # FIX THIS ON SCOUT
      #     };
      #   };
      # };
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
      plugins = {
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

    #    programs.neovim = {
    #      enable = true;
    #      coc.enable = true;
    #      #    defaultEditor = true;
    #      extraConfig = ''
    #        syntax on
    #        set ruler
    #        set number
    #        let no_buffers_menu=1
    #        set smartcase
    #        set ignorecase
    #        set incsearch
    #        set tabstop=4
    #        set softtabstop=4
    #        set shiftwidth=4
    #        set mouse=
    #        set expandtab
    #        colorscheme catppuccin-macchiato
    #      '';
    #      plugins = with pkgs.vimPlugins; [
    #        {
    #          plugin = gitsigns-nvim;
    #          type = "lua";
    #          config = ''
    #            require('gitsigns').setup{
    #              signs = {
    #                add = {  text = '+' },
    #              },
    #              current_line_blame = true,
    #              on_attach = function(bufnr)
    #                local gs = package.loaded.gitsigns
    #
    #                local function map(mode, l, r, opts)
    #                  opts = opts or {}
    #                  opts.buffer = bufnr
    #                  vim.keymap.set(mode, l, r, opts)
    #                end
    #
    #                map('n', '<leader>gb', gs.toggle_current_line_blame)
    #              end,
    #            }
    #          '';
    #        }
    #
    #        vim-nix
    #        vim-eunuch
    #        {
    #          plugin = vim-illuminate;
    #          config = "let g:Illuminate_delay = 100";
    #        }
    #        {
    #          plugin = delimitMate;
    #          config = ''
    #            let delimitMate_expand_cr = 2
    #            let delimitMate_expand_space = 1
    #          '';
    #        }
    #      ];
    #    };

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
        { name = "done"; inherit (done) src; }
        { name = "bass"; inherit (bass) src; }
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
    home.stateVersion = lib.mkDefault "23.05";

    programs.atuin = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      package = pkgs.atuin;
      flags = [ "--disable-up-arrow" ];
      settings = {
        dialect = "uk";
        auto_sync = false;
        update_check = false;
        # sync_frequency = "24h";
        # sync_address = lib.mkIf isWorkstation "https://atuin.spy.rafael.ovh";
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
        show_cpu_frequency = 1;
        show_cpu_temperature = 1;
        show_program_path = 0;
        shadow_other_users = 1;
      };
    };
    programs.direnv = lib.mkIf isWorkstation {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
