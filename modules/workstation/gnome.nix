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
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
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
    caffeine
    #    time-awareness #doesn't support Gnome 45
    pip-on-top
    native-window-placement
  ];

  programs.gnome-terminal.enable = false;

  #Open ports for KDE Connect.
  #networking.firewall =  {
  #  allowedUDPPortRanges = [
  #    { from = 1716; to = 1764; }
  #  ];
  #  allowedTCPPortRanges = [
  #    { from = 1716; to = 1764; }
  #  ];
  #};

  #dconf settings
  hm = { lib, ... }: {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          remember-mount-password = true;
          enabled-extensions = [
            "native-window-placement@gnome-shell-extensions.gcampax.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "gnomebedtime@ionutbortis.gmail.com"
            # "gsconnect@andyholmes.github.io"
            "caffeine@patapon.info"
            # "places-menu@gnome-shell-extensions.gcampax.github.com"
            # "drive-menu@gnome-shell-extensions.gcampax.github.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
            "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
            "pomodoro@arun.codito.in"
            # "time-awareness@gnome-extensions.kapranoff.ru"
            # "browser-tabs@com.github.harshadgavali"
          ];
        };
        # Use `dconf watch /` to track stateful changes you are doing, then set them here.
        # "org/gnome/desktop/input-sources" = {
        #   sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us+altgr-intl" ]) ];
        # xkb-options = [ "lv3:ralt_switch" "ctrl:nocaps" ];

        # };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-temperature = lib.hm.gvariant.mkUint32 1700;
          night-light-schedule-automatic = true;
        };
        "org/gnome/shell/app-switcher" = { current-workspace-only = false; };

        # "org/gnome/eog/ui" = { image-gallery = true; };
        # "/org/gnome/settings-daemon/plugins/power" = {
        #   sleep-inactive-battery-type = "suspend";
        #   sleep-inactive-battery-timeout = lib.hm.gvariant.mkUint32 900;
        #   sleep-inactive-ac-type = "nothing";
        # };

        "org/gnome/mutter" = {
          edge-tiling = lib.mkDefault true;
          workspaces-only-on-primary = true;
          dynamic-workspaces = true;
        };

        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 9;
          focus-mode = "sloppy";
        };
        # disable incompatible shortcuts
        "org/gnome/mutter/wayland/keybindings" = {
          # restore the keyboard shortcuts: disable <super>escape
          restore-shortcuts = [ ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          # hide window: disable <super>h
          minimize = [ "<super>comma" ];
          # switch to workspace left: disable <super>left
          switch-to-workspace-left =
            [ "<primary><super>left" "<primary><super>h" ];
          # switch to workspace right: disable <super>right
          switch-to-workspace-right =
            [ "<primary><super>right" "<primary><super>l" ];
          # maximize window: disable <super>up
          maximize = [ ];
          # restore window: disable <super>down
          unmaximize = [ ];
          # move to monitor up: disable <super><shift>up
          move-to-monitor-up = [ ];
          # move to monitor down: disable <super><shift>down
          move-to-monitor-down = [ ];
          # super + direction keys, move window left and right monitors, or up and down workspaces
          # move window one monitor to the left
          move-to-monitor-left = [ "<Shift><Super>Left" "<Shift><Super>h" ];
          # move window one workspace down
          move-to-workspace-down = [ "<Shift><Super>Down" "<Shift><Super>j" ];
          # move window one workspace up
          move-to-workspace-up = [ "<Shift><Super>Up" "<Shift><Super>k" ];
          # move window one monitor to the right
          move-to-monitor-right = [ "<Shift><Super>Right" "<Shift><Super>l" ];
          # super + ctrl + direction keys, change workspaces, move focus between monitors
          # move to workspace below
          switch-to-workspace-down = [ ];
          # move to workspace above
          switch-to-workspace-up = [ ];
          # toggle maximization state
          toggle-maximized = [ "<super>m" ];
          # close window
          close = [ "<super>q" ];

          switch-to-workspace-1 = [ "<Super>1" ];
          switch-to-workspace-2 = [ "<Super>2" ];
          switch-to-workspace-3 = [ "<Super>3" ];
          switch-to-workspace-4 = [ "<Super>4" ];
          move-to-workspace-1 = [ "<Super><Shift>1" ];
          move-to-workspace-2 = [ "<Super><Shift>2" ];
          move-to-workspace-3 = [ "<Super><Shift>3" ];
          move-to-workspace-4 = [ "<Super><Shift>4" ];
        };
        "org/gnome/shell/keybindings" = {
          open-application-menu = [ ];
          # toggle message tray: disable <super>m
          toggle-message-tray = [ "<super>v" ];
          # show the activities overview: disable <super>s
          toggle-overview = [ ];

          switch-to-application-1 = [ ];
          switch-to-application-2 = [ ];
          switch-to-application-3 = [ ];
          switch-to-application-4 = [ ];
          switch-to-application-5 = [ ];
          switch-to-application-6 = [ ];
          switch-to-application-7 = [ ];
          switch-to-application-8 = [ ];
          switch-to-application-9 = [ ];
        };
        "org/gnome/mutter/keybindings" = {
          # disable tiling to left / right of screen
          toggle-tiled-left = [ ];
          toggle-tiled-right = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          # lock screen
          screensaver = [ "<super>L" ];
          # home folder
          # home = [ "<super>f" ];
          # launch email client
          # email = [ "<super>e" ];
          # # launch web browser
          # www = [ "<super>b" ];
          # rotate video lock
          rotate-video-lock-static = [ ];
          # launch terminal
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<super>return";
            command = "kitty";
            name = "Launch terminal";
          };
      };

    };
  };
}
