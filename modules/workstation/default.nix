{
  config,
  secretsDir,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  isGnome = config.services.xserver.desktopManager.gnome.enable;
  #handlr is SO much better.
  #...but now we're thinking with portals!
  #handlrXdg = pkgs.writeShellScriptBin "xdg-open" ''
  #  #!${pkgs.bash}/bin/bash
  #  set -euo pipefail
  #  exec ${pkgs.handlr}/bin/handlr open "$@"
  #'';
  hmLib = config.home-manager.users."rg".lib;
  XDG_DATA_HOME = config.home-manager.users."rg".home.sessionVariables."XDG_DATA_HOME";
  inherit (lib) mkIf;
in
{
  imports = [
    ./vscode.nix
    ../graphical/default.nix
  ];
  hm.imports = [
    # inputs.lan-mouse.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
    ./ssh-tpm-agent.nix
  ];

  # TODO disable
  hm.services.ssh-tpm-agent.enable = true;

  age.secrets = {
    attic-user-config = {
      file = "${secretsDir}/attic-config.age";
      mode = "400";
      owner = "rg";
    };
  };

  # Custom error sound on e.g firefox when Ctrl-f search fails
  hm.dconf.settings."org/gnome/desktop/sound".event-sounds = true;
  hm.home.file = {
    ".local/share/sounds/__custom/bell-terminal.ogg".source =
      pkgs.copyPathToStore ../../files/bell_sound.ogg;
    ".local/share/sounds/__custom/bell-window-system.ogg".source =
      pkgs.copyPathToStore ../../files/bell_sound.ogg;
    ".local/share/sounds/__custom/index.theme".source = pkgs.writeText "index.theme" ''
      [Sound Theme]
      Name=Custom
      Inherits=freedesktop
      Directories=.
    '';
    ".config/attic/config.toml".source =
      hmLib.file.mkOutOfStoreSymlink "${config.age.secrets.attic-user-config.path}";
  };

  networking.useDHCP = false;
  #Enable SSH agent on boot
  programs.ssh.startAgent = true;

  hm.programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vault.rafael.ovh";
      email = "vault@rafael.ovh";
      # lock_timeout = "3600";
    };
  };
  hm.xdg.desktopEntries = {

    # devdocs = {
    #   name = "DevDocs";
    #   # icon = "${configDir}/icons/Notion.png";
    #   exec = "${pre}/chromium --new-window --app=\"https://devdocs.io\"";
    #   terminal = false;
    #   categories = [ "Application" ];
    # };
    # protonmail = {
    #   name = "Proton Mail";
    #   # icon = "${configDir}/icons/Notion.png";
    #   exec = "${pre}/chromium --new-window --app=\"https://mail.proton.me\"";
    #   terminal = false;
    #   categories = [ "Application" ];
    # };
    # discord = {
    #   name = "Discord";
    #   # icon = "${configDir}/icons/Notion.png";
    #   exec = "${pre}/chromium --new-window --app=\"https://discord.com\"";
    #   terminal = false;
    #   categories = [ "Application" ];
    # };
    # protoncalendar = {
    #   name = "Proton Calendar";
    #   # icon = "${configDir}/icons/Notion.png";
    #   exec = "${pre}/chromium --new-window --app=\"https://calendar.proton.me\"";
    #   terminal = false;
    #   categories = [ "Application" ];
    # };
    # whatsappweb = {
    #   name = "Whatsapp Web";
    #   # icon = "${configDir}/icons/Notion.png";
    #   exec = "${pre}/chromium --new-window --app=\"https://web.whatsapp.com\"";
    #   terminal = false;
    #   categories = [ "Application" ];
    # };
  };

  hm.home.sessionPath = [ "${XDG_DATA_HOME}/cargo/bin" ];

  hm.systemd.user.services.polkit-gnome = lib.mkIf (!isGnome) {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  hm.programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Macchiato";
    settings = {
      font_family = "FantasqueSans Mono Regular";
    };
  };

  #--------------------------------------------
  #--------------Yubikey Settings-------------
  #--------------------------------------------

  security.pam.u2f = {
    enable = false;
    control = "optional";
    settings = {
      cue = true;
    };
  };

  boot.kernelModules = [
    "cdc_ncm"
    "cdc_ether"
  ];

  #Needed for the Yubikey
  services.pcscd.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", GROUP="video", MODE="0664"
    ACTION=="remove", ENV{ID_VENDOR}=="Yubico", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0010|0111|0112|0113|0114|0115|0116|0401|0402|0403|0404|0405|0406|0407|0410", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0061", MODE="0660", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0063", MODE="0660", GROUP="users"

  '';

  #--------------------------------------------
  #--------------Programs----------------------
  #--------------------------------------------
  #

  programs.nm-applet.enable = lib.mkIf (!isGnome) true;

  # hm.services.network-manager-applet.enable = true;
  hm.programs.zathura = {
    enable = true;
    options = {
      recolor = "true";
      selection-clipboard = "clipboard";
      # sandbox = "none";
    };
  };

  hm.xdg = {
    enable = true;
    mime.enable = true;
    # userDirs = {
    #   enable = true;
    #   music = "${config.hm.xdg.userDirs.documents}/Music";
    #   pictures = "${config.hm.xdg.userDirs.documents}/Pictures";
    #   videos = "${config.hm.xdg.userDirs.documents}/Videos";
    # };
  };

  #I prefer state for this.
  # hm.xdg.mimeApps = {
  #   enable = false; #Maybe embrace state for this... Let's see.
  #   defaultApplications = {
  #     "text/html" = [ "firefox.desktop" ];
  #     "x-scheme-handler/http" = [ "firefox.desktop" ];
  #     "x-scheme-handler/https" = [ "firefox.desktop" ];
  #     "x-scheme-handler/about" = [ "firefox.desktop" ];
  #     "x-scheme-handler/unknown" = [ "firefox.desktop" ];
  #     "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  #     "application/zip" = [ "org.gnome.FileRoller.desktop" ];
  #   };
  # };

  programs.adb.enable = true;
  hm.services.flameshot = {
    # enable = lib.mkIf (!isGnome) true;
    enable = true;
    settings = {

      General = {
        showStartupLaunchMessage = false;
        contrastOpacity = 86;
        contrastUiColor = "#cb3939";
        disabledTrayIcon = false;
        drawColor = "#ff2217";
        drawFontSize = 8;
        drawThickness = 4;
        filenamePattern = "Screenshot %d-%m-%Y - %H-%M-%S";
        saveAfterCopy = true;
        savePath = "/home/rg/Pictures/Screenshots";
        savePathFixed = true;
        uiColor = "#db6b73";
      };
    };
  };

  hm.systemd.user.services.flameshot = {
    Unit = {
      After = lib.mkForce "graphical-session.target";
    };
  };

  ##Flameshot requires 'tray.target', which isn't a thing in wayland/gnome/wtv
  #	systemd.user.targets.tray = {
  #Unit = {
  #Description = "Home Manager System Tray";
  #Requires = [ "graphical-session-pre.target" ];
  #};
  #};

  #Enable XDG Desktop Portals
  # Needed for flameshot:
  # https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
  xdg.portal = lib.mkIf (!isGnome) {
    enable = true;
    # xdgOpenUsePortal = true;

    #    https://github.com/emersion/xdg-desktop-portal-wlr/issues/42
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #Note to self: xdg-desktop-portal-gtk is recommended by ...-portal-wlr, but nixos description is "portals for sandboxed apps!?!?"

    # gtkUsePortal = true; # deprecated option? idk
  };

  #Required for GNOME trash to work
  services.gvfs.enable = mkIf (!isGnome) true;

  #Attempt to fix tray icons (Jellyfin-mpv-shim and udiskie in particular)
  services.udev.packages = with pkgs; lib.optionals (!isGnome) [ gnome-settings-daemon ];

  services.earlyoom.enableNotifications = true;

  hm.home.sessionVariables = {
    #xdg-ninja recommendations
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    ANDROID_HOME = "${XDG_DATA_HOME}/android";
    FLY_CONFIG_DIR = "${XDG_DATA_HOME}/fly";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";
    VAGRANT_HOME = "${XDG_DATA_HOME}/vagrant";
    SONARLINT_USER_HOME = "${XDG_DATA_HOME}/sonarlint";
    #xdg-ninja recommendations - end

  };

  environment.persistence."/state".users.rg.directories = [
    ".local/share/android"
    ".local/share/cargo"
    # ".local/share/rustup"
    ".config/Sonixd"
  ];

  users.users.rg.extraGroups = [
    "kvm"
    "wireshark"
  ];

  hm.programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  hm.dconf.settings = {
    # Pomodoro setup.
    "org/gnome/pomodoro/preferences" = {
      enabled-plugins = [
        "sounds"
        "notifications"
        "dark-theme"
      ];
      pomodoro-duration = 3120.0;
      short-break-duration = 1020.0;
      long-break-duration = 2040.0;
    };

    "org/gnome/desktop/background" = {
      primary-color = "#241f31";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
    };
    "org/gnome/desktop/screensaver" = {
      primary-color = "#241f31";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
    };
  };

  hm.programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.command-not-found = {
    enable = false;
  };

  # hm.programs.lan-mouse.settings = {
  #   release_bind = [
  #     "KeyA"
  #     "KeyS"
  #     "KeyD"
  #     "KeyF"
  #   ];
  #   port = 7742;
  #   frontend = "gtk";
  #   systemd = true;
  # };

  networking.firewall = rec {
    allowedTCPPorts = [
      53317 # LocalSend (installed thru flatpak)
      7236 # Gnome Network Displays
      1844 # QBT
    ];
    allowedUDPPorts = [
      53317 # LocalSend (installed thru flatpak)
      7236 # Gnome Network Displays
      1844 # QBT
    ];
    # For KDEConnect (or reimplementations of it )
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    # For KDEConnect (or reimplementations of it )
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  hm.home.packages = with pkgs; [
    xdg-ninja
    #Gnome and related stuff
    gnome-pomodoro
    seahorse
    file-roller
    nautilus
    loupe
    gparted
    pavucontrol
    pwvucontrol
    xorg.xlsclients
    xorg.xeyes
    playerctl
    virt-manager
    riff
    steam-run
    shellcheck
    sonixd
    libnotify
    nodePackages.prettier
    unstable.yt-dlp
    yubioath-flutter
    cargo

  ];
  environment.systemPackages = with pkgs; [
    mypkgs.agenix
    attic-client
    pamixer
    mypkgs.flatpak-xdg-utils
    # handlrXdg
    nixpkgs-fmt

    yubikey-manager
    udiskie
    libqalculate
    ntfs3g
    ripgrep-all
    udisks2

    # :eyes:
    # Too new a project. e.g, `rm` hangs on pipes created with mkfifo
    # (pkgs.uutils-coreutils.override { prefix = ""; })
  ];
}
