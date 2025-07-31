{ pkgs, ... }:
{
  imports = [
    ./pop-shell.nix
    ./wayland.nix
  ];
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages =
    (with pkgs; [
      cheese
      gnome-photos
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      gnome-maps
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-tour
      xterm
      gedit
    ])
    ++ (with pkgs.gnome; [ ]);

  environment.systemPackages = with pkgs; [ gnome-tweaks ];
  programs.gnome-terminal.enable = false;

  environment.persistence."/pst".users.rg.directories = [ ".config/valent" ];
  environment.persistence."/state".users.rg.directories = [ ".local/share/gnome-shell" ];
  #dconf settings
  hm =
    { lib, ... }:
    {

      programs.gnome-shell.enable = true;
      programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
        # { package = gsconnect; } # appears to be abandoned?
        # { package = valent; } # kde connect reimplementation - nixpkgs version not compatible w/ latest gnome
        { package = appindicator; }
        { package = caffeine; }
        # { package = cronomix; } # not compatible with cur. gnome
        { package = launch-new-instance; }
        { package = just-perfection; }
        { package = space-bar; }
        { package = vitals; }
        # { package = pip-on-top; } # not compatible with cur. gnome
      ];

      dconf.enable = true;
      dconf.settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          remember-mount-password = true;
        };
        # Use `dconf watch /` to track stateful changes you are doing, then set them here.
        "org/gnome/desktop/input-sources" = {
          sources = [
            (lib.hm.gvariant.mkTuple [
              "xkb"
              "us"
            ])
            (lib.hm.gvariant.mkTuple [
              "xkb"
              "pt"
            ])
            # xkb-options = [ "lv3:ralt_switch" "ctrl:nocaps" ];
          ];
        };

        "org/gnome/GWeather4" = {
          "temperature-unit" = "centigrade";
        };
        "org/gnome/desktop/peripherals/keyboard" = {
          delay = lib.hm.gvariant.mkUint32 246;
          repeat-interval = lib.hm.gvariant.mkUint32 18;
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-temperature = lib.hm.gvariant.mkUint32 1700;
          night-light-schedule-automatic = true;
        };
        "org/gnome/shell/app-switcher" = {
          current-workspace-only = false;
        };

        # "org/gnome/eog/ui" = { image-gallery = true; };
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-battery-type = "suspend";
          sleep-inactive-battery-timeout = lib.hm.gvariant.mkUint32 900;
          sleep-inactive-ac-type = "nothing";
        };
        # };

        "org/gnome/shell/extensions/bedtime-mode".bedtime-mode-active = false;

        #TODO: would be cooler if these two were only enabled on laptops.
        "org/gnome/desktop/a11y".always-show-universal-access-status = lib.mkDefault true;
        "org/gnome/desktop/interface" = {
          color-schema = "prefer-dark";
          text-scaling-factor = lib.mkDefault 1.25;
          show-battery-percentage = true;
        };

        "org/gnome/mutter" = {
          edge-tiling = lib.mkDefault true;
          workspaces-only-on-primary = true;
          dynamic-workspaces = false;
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
          switch-to-workspace-left = [
            "<primary><super>left"
            "<primary><super>h"
          ];
          # switch to workspace right: disable <super>right
          switch-to-workspace-right = [
            "<primary><super>right"
            "<primary><super>l"
          ];
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
          move-to-monitor-left = [
            "<Shift><Super>Left"
            "<Shift><Super>h"
          ];
          # move window one workspace down
          move-to-workspace-down = [
            "<Shift><Super>Down"
            "<Shift><Super>j"
          ];
          # move window one workspace up
          move-to-workspace-up = [
            "<Shift><Super>Up"
            "<Shift><Super>k"
          ];
          # move window one monitor to the right
          move-to-monitor-right = [
            "<Shift><Super>Right"
            "<Shift><Super>l"
          ];
          # super + ctrl + direction keys, change workspaces, move focus between monitors
          # move to workspace below
          switch-to-workspace-down = [ ];
          # move to workspace above
          switch-to-workspace-up = [ ];
          # toggle maximization state
          toggle-maximized = [ "<super>m" ];
          # close window
          close = [ "<super>q" ];

        }
        // (builtins.listToAttrs (
          lib.forEach (lib.range 1 9) (
            x: lib.nameValuePair "switch-to-workspace-${toString x}" [ "<Super>${toString x}" ]
          )
        ))
        // (builtins.listToAttrs (
          lib.forEach (lib.range 1 9) (
            x: lib.nameValuePair "move-to-workspace-${toString x}" [ "<Super><Shift>${toString x}" ]
          )
        ));
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
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<super>return";
          command = "kitty";
          name = "Launch terminal";
        };
        # Configure Just Perfection
        "org/gnome/shell/extensions/just-perfection" = {
          animation = 2;
          dash-app-running = true;
          workspace = true;
          workspace-popup = false;
        };
        # Configure Blur My Shell
        "org/gnome/shell/extensions/blur-my-shell/appfolder".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/lockscreen".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/screenshot".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/window-list".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
        "org/gnome/shell/extensions/blur-my-shell/overview".blur = true;
        "org/gnome/shell/extensions/blur-my-shell/overview".pipeline = "pipeline_default";
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".blur = true;
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".brightness = "0/6";
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".sigma = 30;
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".static-blur = true;
        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".style-dash-to-dock = 0;
        # Configure Space Bar
        "org/gnome/shell/extensions/space-bar/behavior".smart-workspace-names = false;
        "org/gnome/shell/extensions/space-bar/shortcuts".enable-activate-workspace-shortcuts = false;
        "org/gnome/shell/extensions/space-bar/shortcuts".enable-move-to-workspace-shortcuts = true;
        "org/gnome/shell/extensions/space-bar/shortcuts".open-menu =
          lib.hm.gvariant.mkEmptyArray lib.hm.gvariant.type.string;
      };

    };
}
