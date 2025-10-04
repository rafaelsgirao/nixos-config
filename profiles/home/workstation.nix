_: {

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Macchiato";
    font.package = fonts.nerd-fonts.fantasque-sans-mono;
    settings = {
      font_family = "FantasqueSans Mono Regular";
    };
  };

  programs.mpv = {
    enable = true;
    # scripts = [
    # pkgs.mpvScripts.mpris
    # ];
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
}
