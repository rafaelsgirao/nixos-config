_:
{
  hm.programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.readFile ../files/waybar/style.css;
    # settings = (builtins.fromJSON (builtins.readFile ../files/waybar/config ) );
    settings.mainBar = {
      layer = "top";
      position = "bottom";
      height = 34;
      modules-left = [ "idle_inhibitor" "sway/mode" "sway/workspaces" ];
      modules-right =
        [ "custom/swaytimer" "pulseaudio" "battery" "clock" "tray" ];
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      "sway/mode".format = "{}";
      "custom/swaytimer" = {
        format = "⏳ {}";
        max-length = 10;
        exec = "exec ${../files/sway_timer.py}";
      };
      battery = {
        interval = 2;
        states = {
          pre-warning = 30;
          warning = 20;
          critical = 10;
        };
        format = "{icon} - {capacity}%";
        format-charging = " {icon} {capacity}%";
        format-plugged = "  {icon} {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = [ "" "" "" "" "" ];
      };
      pulseaudio = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{icon} {volume}% {format_source}";
        format-bluetooth-muted = "{icon}  {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
      clock = {
        interval = 5;
        format = "🕒 {:%a %d/%b %H:%M}";
        format-alt = "🕒 {:%a %F %T}";
        tooltip = false;
      };
      tray = {
        # icon-size = 21;
        spacing = 10;
      };
    };
  };

}
