{ pkgs, ... }: {
  imports = [
    ./pop-shell.nix
    ./wayland.nix
  ];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    xterm
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  environment.systemPackages = with pkgs.gnomeExtensions; [
    gnome-bedtime
    gsconnect
    caffeine
    time-awareness
    browser-tabs
    pip-on-top
  ];
  services.gnome.gnome-browser-connector.enable = true;

  programs.gnome-terminal.enable = false;

  #Open port for KDE Connect.
  #networking.firewall = lib.mkIf (config.networking.hostName != "medic") {
  #  allowedUDPPortRanges = [
  #    { from = 1716; to = 1764; }
  #  ];
  #  allowedTCPPortRanges = [
  #    { from = 1716; to = 1764; }
  #  ];
  #};
}
