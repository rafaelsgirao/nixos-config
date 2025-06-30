{ pkgs, ... }:
{

  # improve desktop responsiveness when updating the system
  nix.daemonCPUSchedPolicy = "idle";
  # hm.services.safeeyes.enable = true;
  hm.gtk = {
    enable = true;
    theme = {
      package = pkgs.orchis-theme;
      name = "Orchis-Dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      name = "Adwaita";
    };
  };

  # TAKEN FROM https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/default.nix
  # ---
  hm.qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "adwaita"; # "value gnome is deprecated"
  };

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pulseaudio.enable = false; # Gnome can be stupid and try to enable this.

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  #Fonts
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    roboto
    noto-fonts-cjk-sans
    noto-fonts-extra
    noto-fonts-emoji
    fantasque-sans-mono
    font-awesome
    #    powerline-fonts
    source-code-pro
    overpass
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.dejavu-sans-mono
  ];

  hardware.acpilight.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;
}
