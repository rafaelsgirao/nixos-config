{ pkgs, config, lib, ... }:
let

  # swayfx-unwrapped = pkgs.callPackage ../packages/swayfx/default.nix { };
  # swayfx-rg = pkgs.sway.override { sway-unwrapped = swayfx-unwrapped; };
  rglock = pkgs.writeTextFile {
    name = "rglock";
    destination = "/bin/rglock";
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.swaylock-effects}/bin/swaylock \
        --ignore-empty-password \
        --daemonize \
      	--screenshots \
      	--clock \
      	--indicator \
      	--indicator-radius 100 \
      	--indicator-thickness 7 \
      	--effect-blur 7x5 \
      	--effect-vignette 0.5:0.5 \
      	--ring-color bb00cc \
      	--key-hl-color 880033 \
      	--line-color 00000000 \
      	--inside-color 00000088 \
      	--separator-color 00000000 \
      	--fade-in 0.2 \
        $@
    '';
  };
  noNet = "${pkgs.networkmanager}/bin/nmcli networking off && ${pkgs.networkmanager}/bin/nmcli radio all off";
in
{
  imports = [
    ./wayland.nix
  ];
  # services.xserver.enable = lib.mkDefault true;
  # services.xserver.enable = true;
  # services.xserver.displayManager = {
  #   # sessionPackages = [ pkgs.unstable ];
  #   gdm.enable = true;
  # };

  #Needed for sway.
  programs.sway = {
    enable = true;
    # package = swayfx-rg; #Warning: crashes frequently
    # package = pkgs.sway;
    # package = pkgs.old.sway;

    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      #Flameshot asks for this
      export XDG_SESSION_DESKTOP=sway
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    extraPackages = [ ];

  };

  security.polkit.enable = true;
  hm.wayland.windowManager.sway =
    let
      ws1 = "1|dev";
      ws2 = "2|www";
      ws3 = "3|";
      ws4 = "4|🎵";
      ws5 = "5|";
      ws6 = "6|";
      ws7 = "7|";
      ws8 = "8|💬";
      ws9 = "9|🗑️";
      ws10 = "10|⏳";
      mod = "Mod4";
      playercmd = "${pkgs.playerctl}/bin/playerctl -p Sonixd";
      pamixer = "${pkgs.pamixer}/bin/pamixer";
    in
    {
      enable = true;
      # package =
      #   let
      #     cfg = config.hm.wayland.windowManager.sway;
      #     # cfg = config.programs.sway;
      #   in
      #   swayfx-rg.override {
      #     extraSessionCommands = cfg.extraSessionCommands;
      #     extraOptions = cfg.extraOptions;
      #     withBaseWrapper = cfg.wrapperFeatures.base;
      #     withGtkWrapper = cfg.wrapperFeatures.gtk;
      #   };
      # package = null; #Managed by NIxOS
      # systemd.enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraSessionCommands = ''
        #Flameshot asks for this
        export XDG_SESSION_DESKTOP=sway
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      systemdIntegration = true;
      config = {
        output."*" = {
          bg = "#000000 solid_color";
        };
        fonts = {
          names = [ "pango" ];
          style = "monospace";
          size = 10.0;
        };
        modifier = mod;
        terminal = "kitty";
        assigns = {
          "${ws8}" = [
            { app_id = "signal"; }
            { app_id = "ferdium"; }
            { app_id = "thunderbird"; }
          ];
        };
        window = { border = 0; };
        keybindings = lib.mkOptionDefault {
          "${mod}+1" = "workspace ${ws1}";
          "${mod}+2" = "workspace ${ws2}";
          "${mod}+3" = "workspace ${ws3}";
          "${mod}+4" = "workspace ${ws4}";
          "${mod}+5" = "workspace ${ws5}";
          "${mod}+6" = "workspace ${ws6}";
          "${mod}+7" = "workspace ${ws7}";
          "${mod}+8" = "workspace ${ws8}";
          "${mod}+9" = "workspace ${ws9}";
          "${mod}+0" = "workspace ${ws10}";

          "${mod}+Shift+1" = "move container to workspace ${ws1}";
          "${mod}+Shift+2" = "move container to workspace ${ws2}";
          "${mod}+Shift+3" = "move container to workspace ${ws3}";
          "${mod}+Shift+4" = "move container to workspace ${ws4}";
          "${mod}+Shift+5" = "move container to workspace ${ws5}";
          "${mod}+Shift+6" = "move container to workspace ${ws6}";
          "${mod}+Shift+7" = "move container to workspace ${ws7}";
          "${mod}+Shift+8" = "move container to workspace ${ws8}";
          "${mod}+Shift+9" = "move container to workspace ${ws9}";
          "${mod}+Shift+0" = "move container to workspace ${ws10}";

          "${mod}+minus" = "move scratchpad";
          "${mod}+plus" = "scratchpad show";

          "${mod}+Tab" = "workspace next";
          "${mod}+Shift+Tab" = "workspace prev";

          "${mod}+b" = "exec loginctl lock-session";
          "${mod}+Shift+b" = "exec systemctl suspend";
          "Print" = "exec flameshot gui";
          "${mod}+d" = "exec rofi-launcher";
          "${mod}+o" = "exec rofi-ykman";
          "${mod}+m" = "exec rofi-bluetooth";
          "${mod}+r" = "mode resize";
          "${mod}+c" = "move absolute position center";
          "${mod}+Return" = "exec kitty";
          "${mod}+Shift+q" = "kill";
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+e" =
            "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'";

          "${mod}+g" = "split h";
          # "${mod}+f" = "fullscreen toggle";
          # "${mod}+w" = "layout tabbed";
          # "${mod}+e" = "layout toggle split";
          # "${mod}+Shift+Space" = "floating toggle";
          # "${mod}+Space" = "floating toggle";

          # "${mod}+h" = "focus left";
          # "${mod}+j" = "focus down";
          # "${mod}+k" = "focus up";
          # "${mod}+l" = "focus right";

          # "${mod}+Shift+h" = "move left";
          # "${mod}+Shift+j" = "move down";
          # "${mod}+Shift+k" = "move up";
          # "${mod}+Shift+l" = "move right";

          # "${mod}+Left" = "focus left";
          # "${mod}+Down" = "focus down";
          # "${mod}+Up" = "focus up";
          # "${mod}+Right" = "focus right";

          # "${mod}+Shift+Left" = "move left";
          # "${mod}+Shift+Down" = "move down";
          # "${mod}+Shift+Up" = "move up";
          # "${mod}+Shift+Right" = "move right";

          "XF86AudioRaiseVolume" = "exec ${pamixer} -i 5";
          "XF86AudioLowerVolume" = "exec ${pamixer} -d 5";
          "XF86AudioMute" = "exec ${pamixer} --toggle-mute";
          "XF86AudioMicMute" = "exec ${pamixer} --default-source -t";
          "XF86AudioPlay" = "exec ${playercmd} play-pause";
          "XF86AudioPrev" = "exec ${playercmd} previous";
          "XF86AudioNext" = "exec ${playercmd} next";
        };
        # window.commands = [
        #     {
        #         command = "floating enable";
        #     }
        # ];
        floating = {
          criteria = [
            { app_id = "flameshot"; }
            { title = "Firefox — Sharing Indicator"; }
          ];
          titlebar = false;
          border = 0;
        };
        input = {
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
          "type:keyboard" = {
            xkb_layout = "pt";
            xkb_options = "grp:rctrl_toggle";
            repeat_delay = "250";
            repeat_rate = "100";
          };
        };
        # config = null;
        # config = {
        bars = [ ];
        #   modes = null;
        #   colors = null;
        # };
        # extraConfigEarly = (builtins.readFile ../files/sway-config);
        startup = [
          {
            command = "systemctl restart --user waybar";
            always = true;
          }
          {
            command = "systemctl restart --user flameshot";
          }
          {
            command = "systemctl restart --user nm-applet";
          }
          { command = "${pamixer} -m "; }
          { command = "${pamixer} -m --default-source -m "; }
        ];
      };
      extraConfig = ''
        for_window [class="NoiseTorch"] floating enable, resize set width 1030 height 710
        for_window [app_id="pavucontrol"] floating enable, resize set width 1030 height 710
        for_window [title="(?:Open|Save) (?:File|Folder|As)"] floating enable, resize set width 1030 height 710
        for_window [app_id="discord"] saturation set 0 #wayland
        for_window [app_id="ferdium"] saturation set 0 # wayland
        for_window [app_id="chromium-browser"] saturation set 0
        for_window [app_id="thunderbird"] saturation set 0
        seat * hide_cursor 2000
        seat * hide_cursor when-typing enable
        bindsym --locked XF86MonBrightnessUp exec xbacklight -inc 5
        bindsym --locked XF86MonBrightnessDown exec xbacklight -dec 5
      '';
    };
  # Allow swaylock to unlock the computer for us
  security.pam.services.swaylock = { text = "auth include login"; };

  xdg.portal.wlr.enable = true;
  hm.services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${rglock}/bin/rglock";
      }
      {
        event = "lock";
        command = "${rglock}/bin/rglock";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off' && ${noNet}";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
      {
        timeout = 180;
        command = "${rglock}/bin/rglock && ${noNet}";
      }
    ];
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  hm.home.packages = with pkgs; [
    rglock
    swaybg
    slurp # Required for xdg-desktop-portal-wlr.
    grim # Required for flameshot. https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
  ];
  environment.systemPackages = with pkgs; [
    qt6.qtwayland # see comment in sway.extraSessionCommands
    libsForQt5.qt5.qtwayland

    lm_sensors
    glib # gsettings
  ];
}
