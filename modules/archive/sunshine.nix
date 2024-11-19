{ pkgs, ... }:

let
  # sunshinePkg = pkgs.sunshine;
  __configStrings = config: (map (key: "${key} = ${config.${key}}") (builtins.attrNames config));
  genConfig = config: (builtins.concatStringsSep "\n" (__configStrings config));
  sunshinePkg = pkgs.sunshine.override {
    cudaSupport = true;
    stdenv = pkgs.cudaPackages.backendStdenv;
  };
  runtimeDir = "/run/sunshine";
  RuntimeDirectory = builtins.baseNameOf runtimeDir;
  RuntimeDirectoryMode = "0700";
  envs = {
    DISPLAY = ":0";
    XDG_RUNTIME_DIR = runtimeDir;
    WAYLAND_DISPLAY = runtimeDir + "/wayland-1";
    PULSE_SERVER = "unix:${runtimeDir}/pulse/native";
  };
in
{
  programs.steam.enable = true;
  security.wrappers.seatd-launch = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.seatd}/bin/seatd-launch";
  };

  users.users.sunshine = {
    isNormalUser = true;
    uid = 1010;
    extraGroups = [
      "video"
      "input"
      "render"
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;

    };
  };
  environment.persistence."/state".directories = [ "/home/sunshine" ];
  hardware.opengl.enable = true;

  # https://docs.lizardbyte.dev/projects/sunshine/en/latest/about/usage.html#setup
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

  security.rtkit.enable = true;

  # https://wiki.archlinux.org/title/Wayland
  # https://wayland.pages.freedesktop.org/weston/toc/running-weston.html
  #    https://overflow.lunar.icu/exchange/unix/questions/653672/virtual-wayland-display-server-possible
  #systemd.services.weston = {
  #  environment = {
  #    XDG_RUNTIME_DIR = "/run/sunshine-weston";
  #  };
  #  serviceConfig = {
  #    # DynamicUser = true;
  #    User = "sunshine";
  #    # ExecStart = "${pkgs.weston}/bin/weston --no-config --socket=wl-sunshine --backend=headless --renderer=gl
  #    ExecStart = "${pkgs.weston}/bin/weston --no-config --socket=/run/sunshine-weston/wl-sunshine --backend=headless --renderer=gl
  #";

  #    # https://ma.ttias.be/auto-restart-crashed-service-systemd/
  #    Restart = "on-failure";
  #    RestartSec = "5s";

  #    RuntimeDirectory = "sunshine-weston";
  #    inherit RuntimeDirectoryMode; #weston complained of systemd default (0755)
  #  };
  # };

  systemd.services.sunshine-display =
    let
      configFile = pkgs.writeText "wayfire_config.ini" ''
        [input-device:wlr_virtual_pointer_v1]
        output = HEADLESS-1
            
        [output:HEADLESS-1]
        mode = 1920x1080
        position = 4160, 0
        scale = 1.000000
        transform = normal
      '';
    in
    {
      #References:
      # https://github.com/LizardByte/Sunshine/issues/1660
      # https://github.com/WayfireWM/wayfire/issues/1710
      # https://github.com/WayfireWM/wayfire/issues/1730
      environment = {
        WLR_RENDER_DRM_DEVICE = "/dev/dri/renderD128"; # renderD128 is intel/AMD
        WLR_LIBINPUT_NO_DEVICES = "1";
        WLR_BACKENDS = "headless,libinput";
        WAYFIRE_CONFIG_FILE = configFile;
        _WAYFIRE_SOCKET = runtimeDir + "/wl-sunshine"; # FIXME: not working. use default socket name (wayland-1) at runtimeDir
      } // envs;

      serviceConfig = {
        # DynamicUser = true;
        User = "sunshine";
        ExecStart = "/run/wrappers/bin/seatd-launch -- ${pkgs.wayfire}/bin/wayfire";

        # https://ma.ttias.be/auto-restart-crashed-service-systemd/
        Restart = "on-failure";
        RestartSec = "5s";

        inherit RuntimeDirectory;
        inherit RuntimeDirectoryMode;
        # # RuntimeDirectory = runtimeDirName;
        # RuntimeDirectoryMode = runtimeDirPerms;
      };
    };

  systemd.services.sunshine-pipewire = {
    after = [ "sunshine-display.service" ];
    # wantedBy = [ "network.target" ];
    bindsTo = [ "sunshine-display.service" ];

    environment = envs;

    serviceConfig = {
      # DynamicUser = true;
      User = "sunshine";
      ExecStart = "${pkgs.pipewire}/bin/pipewire";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "5s";

      inherit RuntimeDirectory;

      inherit RuntimeDirectoryMode;
    };
  };

  systemd.services.sunshine-pulse = {
    after = [ "sunshine-pipewire.service" ];
    # wantedBy = [ "network.target" ];
    bindsTo = [ "sunshine-pipewire.service" ];
    environment = envs;

    serviceConfig = {
      # DynamicUser = true;
      User = "sunshine";
      ExecStart = "${pkgs.pipewire}/bin/pipewire-pulse";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "5s";

      inherit RuntimeDirectory;
      inherit RuntimeDirectoryMode;
    };
  };

  systemd.services.sunshine-app = {
    after = [
      "sunshine-display.service"
      "sunshine-pulse.service"
    ];
    # wantedBy = [ "network.target" ];
    bindsTo = [
      "sunshine-display.service"
      "sunshine-pulse.service"
    ];
    environment = {
      HOME = "/library/games/.sunshine-app";
    } // envs;
    path = with pkgs; [
      heroic
      lutris
    ];

    #Sunshine doesn't respect XDG:
    #      https://github.com/LizardByte/Sunshine/blob/35b785ebb8d95c88e42a808b51a9eb6e608fb5d2/src/platform/linux/misc.cpp#L103
    # XDG_CONFIG_HOME = "/library/games/.sunshine-app";

    serviceConfig =
      let
        appsConfig = pkgs.writeText "sunshine_apps.json" (
          builtins.toJSON {
            env = {
              PATH = "$(PATH):$(HOME)/.local/bin";
            };
            apps = [
              {
                name = "Desktop";
                image-path = "desktop.png";
              }
              {
                name = "(NixOS) Steam Big Picture";
                detached = [
                  "${pkgs.util-linux}/bin/setsid /run/current-system/sw/bin/steam steam://open/bigpicture"
                ];
                image-path = "steam.png";
              }
              {
                name = "(NixOS) Kitty";
                detached = [ "${pkgs.util-linux}/bin/setsid ${pkgs.kitty}/bin/kitty" ];
                image-path = "${pkgs.kitty}/lib/kitty/logo/kitty.png";
              }
              {
                name = "(NixOS) Steam";
                detached = [ "${pkgs.util-linux}/bin/setsid /run/current-system/sw/bin/steam" ];
                image-path = "steam.png";
              }
            ];

          }
        );
        configFile = pkgs.writeText "sunshine_config.conf" (genConfig {
          audio_sink = "sink-sunshine-stereo.monitor";
          file_apps = "${appsConfig}";
          capture = "wlr";
          encoder = "nvenc";
        });

      in
      {
        # DynamicUser = true;
        User = "sunshine";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart = "${sunshinePkg}/bin/sunshine ${configFile}";

        # https://ma.ttias.be/auto-restart-crashed-service-systemd/
        Restart = "on-failure";
        RestartSec = "5s";

        inherit RuntimeDirectory;
        inherit RuntimeDirectoryMode;
      };
  };
}
