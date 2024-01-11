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
    imports = [ (inputs.impermanence + "/home-manager.nix") ];
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
      ".local/bin/portcheck".source = pkgs.copyPathToStore ../files/portcheck;
      ".local/bin/randomport".source = pkgs.copyPathToStore ../files/randomport;
    } // lib.optionalAttrs isWorkstation {
      ".config/fish/fish_history".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.config/fish/fish_history";
      ".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.config/mimeapps.list";
      ".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.config/Code/User/settings.json";
      ".local/share/nix/trusted-settings.json".source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.local/share/nix/trusted-settings.json";
    };

    programs.ssh =
      {
        enable = true;
        extraConfig = lib.mkIf isWorkstation
          ''
            AddKeysToAgent yes
            Include ${config'.age.secrets.ssh-config.path}
          '';
      };

    programs.eza = {
      enable = true;
      enableAliases = true;
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

    programs.neovim = {
      enable = true;
      coc.enable = true;
      #    defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
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
        colorscheme catppuccin-macchiato
      '';
      plugins = with pkgs.vimPlugins; [
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            require('gitsigns').setup{
              signs = {
                add = {  text = '+' },
              },
              current_line_blame = true,
              on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                  opts = opts or {}
                  opts.buffer = bufnr
                  vim.keymap.set(mode, l, r, opts)
                end

                map('n', '<leader>gb', gs.toggle_current_line_blame)
              end,
            }
          '';
        }

        vim-wakatime
        vim-nix
        vim-commentary
        vim-eunuch
        catppuccin-nvim
        {
          plugin = vim-illuminate;
          config = "let g:Illuminate_delay = 100";
        }
        {
          plugin = delimitMate;
          config = ''
            let delimitMate_expand_cr = 2
            let delimitMate_expand_space = 1
          '';
        }
      ];
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
        # "sudo-" = "sudoedit";
        se = "sudoedit";
        "_" = "sudo";
      };
      plugins = with pkgs.fishPlugins; [
        { name = "wakatime-fish"; inherit (wakatime-fish) src; }
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
        cpugov = ''
          if count $argv > /dev/null
          	echo "$argv" | ${pkgs.sudo}/bin/sudo ${pkgs.coreutils}/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
          else
          	#Assume all CPUs have the same governor which is reasonable
                 ${pkgs.coreutils}/bin/cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
          end
        '';
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
      theme = ''
        (
          selected_tab: Reset,
          command_fg: Rgb(202, 211, 245),
          selection_bg: Rgb(91, 96, 120),
          selection_fg: Rgb(202, 211, 245),
          cmdbar_bg: Rgb(30, 32, 48),
          cmdbar_extra_lines_bg: Rgb(30, 32, 48),
          disabled_fg: Rgb(128, 135, 162),
          diff_line_add: Rgb(166, 218, 149),
          diff_line_delete: Rgb(237, 135, 150),
          diff_file_added: Rgb(238, 212, 159),
          diff_file_removed: Rgb(238, 153, 160),
          diff_file_moved: Rgb(198, 160, 246),
          diff_file_modified: Rgb(245, 169, 127),
          commit_hash: Rgb(183, 189, 248),
          commit_time: Rgb(184, 192, 224),
          commit_author: Rgb(125, 196, 228),
          danger_fg: Rgb(237, 135, 150),
          push_gauge_bg: Rgb(138, 173, 244),
          push_gauge_fg: Rgb(36, 39, 58),
          tag_fg: Rgb(244, 219, 214),
          branch_fg: Rgb(139, 213, 202)
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
