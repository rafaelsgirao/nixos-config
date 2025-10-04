{ pkgs, ... }:
{

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Macchiato";
    font.package = pkgs.nerd-fonts.fantasque-sans-mono;

    # https://wiki.nixos.org/wiki/Fonts#What_font_names_can_be_used_in_fonts.fontconfig.defaultFonts.monospace?
    font.name = "FantasqueSansM Nerd Font Mono";
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
