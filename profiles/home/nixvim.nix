_: {

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
}
