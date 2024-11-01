# Stolen from:
# https://github.com/carjorvaz/nixos/blob/9b48b506c5507eff6b76f8d05d5cd4057e7c0fd2/profiles/graphical/gnome/pop-shell.nix#L1
# Go ahead, sue me.

{ pkgs, ... }:

{
  hm =
    { lib, ... }:
    {
      programs.gnome-shell.enable = true;
      programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
        { package = native-window-placement; }
        { package = pop-shell; }
      ];
      home.packages = with pkgs; [ pop-launcher ];
      dconf = {
        enable = true;
        settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "pop-shell@system76.com" ];
          };

          # Use `dconf watch /` to track stateful changes you are doing, then set them here.

          # Enable and configure pop-shell, see:
          # - https://github.com/pop-os/shell/blob/master_jammy/scripts/configure.sh
          # - https://github.com/trevex/dotfiles/blob/5b3b0e2b9624fbedd1a64d378e18aea6efef6db9/modules/nixos/desktop/gnome/default.nix#L60
          "org/gnome/mutter".edge-tiling = false;

          "org/gnome/shell/extensions/pop-shell" = {
            active-hint = true;
            smart-gaps = true;
            tile-by-default = true;
            gap-outer = lib.hm.gvariant.mkUint32 0;
            gap-inner = lib.hm.gvariant.mkUint32 0;
          };

        };
      };
    };
}
