{
  config,
  inputs,
  profiles,
  pkgs,
  ...
}:
{
  imports = with profiles.home; [
    nixvim
    git

    inputs.nixvim.homeModules.nixvim
  ];

  home.preferXdgDirectories = true;
  xdg.enable = true;
  home.enableNixpkgsReleaseCheck = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    MANROFFOPT = "-c";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
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

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
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
      # daemon = {
      #   enabled = true;
      #   # TODO: ugly hardcoded path!
      #   socket_path = "/run/user/1000/atuin.sock";
      # };
      sync = {
        records = true;
      };
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
      show_program_path = 0;
      shadow_other_users = 1;
      hide_kernel_threads = 1;
      hide_userland_threads = 1;
    }
    // {
      show_cpu_frequency = 1;
      show_cpu_temperature = 1;
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
