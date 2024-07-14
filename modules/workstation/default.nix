{ config, inputs, lib, pkgs, ... }:
let
  isGnome = config.services.xserver.desktopManager.gnome.enable;
  #handlr is SO much better.
  #...but now we're thinking with portals!
  #handlrXdg = pkgs.writeShellScriptBin "xdg-open" ''
  #  #!${pkgs.bash}/bin/bash
  #  set -euo pipefail
  #  exec ${pkgs.handlr}/bin/handlr open "$@"
  #'';
  inherit (lib) mkIf;
in
{
  imports = [
    ./vscode.nix
    inputs.nix-index-database.nixosModules.nix-index
  ];
  hm.imports = [
    inputs.lan-mouse.homeManagerModules.default
    ./ssh-tpm-agent.nix
  ];
  # improve desktop responsiveness when updating the system
  nix.daemonCPUSchedPolicy = "idle";

  hm.services.ssh-tpm-agent.enable = true;
  programs.ccache.enable = true;

  # programs.kdeconnect = lib.mkIf (config.rg.class == "workstation") {
  #   enable = true;
  #   package = pkgs.gnomeExtensions.gsconnect;

  # };

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
  hm.services.safeeyes.enable = true;
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
    platformTheme.name = "gtk";
  };


  hm.xdg.desktopEntries =
    {

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

  # ---
  # hm.fonts.fontconfig.enable = true;
  hm.home.sessionPath = [ "$HOME/.local/bin" ];

  hm.systemd.user.services.polkit-gnome = lib.mkIf (!isGnome) {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  hm.programs.kitty = {
    enable = true;
    theme = "Catppuccin-Macchiato";
    settings = { font_family = "FantasqueSans Mono Regular"; };
  };


  # rtkit is optional but recommended
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false; #Gnome can be stupid and try to enable this.

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  location.latitude = 38.7223;
  location.longitude = -9.1393;
  location.provider = "manual";

  #Fonts
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    roboto
    noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    fantasque-sans-mono
    font-awesome
    #    powerline-fonts
    source-code-pro
    overpass
    (nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" "DejaVuSansMono" ];
    })
  ];

  hardware.acpilight.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;


  #--------------------------------------------
  #--------------Yubikey Settings-------------
  #--------------------------------------------

  security.pam.u2f = {
    enable = false;
    control = "optional";
    cue = true;
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
  #hm.services.flameshot = {
  #  # enable = lib.mkIf (!isGnome) true;
  #  enable = true;
  #  settings = {

  #    General = {
  #      showStartupLaunchMessage = false;
  #      contrastOpacity = 86;
  #      contrastUiColor = "#cb3939";
  #      disabledTrayIcon = false;
  #      drawColor = "#ff2217";
  #      drawFontSize = 8;
  #      drawThickness = 4;
  #      filenamePattern = "Screenshot %d-%m-%Y - %H-%M-%S";
  #      saveAfterCopy = true;
  #      savePath = "/home/rg/Screenshots";
  #      savePathFixed = true;
  #      uiColor = "#db6b73";
  #    };


  #  };
  #};

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
  services.udev.packages = with pkgs; lib.optionals (!isGnome) [ gnome.gnome-settings-daemon ];

  services.earlyoom.enableNotifications = true;

  hm.home.sessionVariables = {
    #xdg-ninja recommendations
    CARGO_HOME = "\"$XDG_DATA_HOME\"/rustup";
    RUSTUP_HOME = "\"$XDG_DATA_HOME\"/cargo";
    ANDROID_HOME = "\"$XDG_DATA_HOME\"/android";
    FLY_CONFIG_DIR = "\"$XDG_STATE_HOME\"/fly";
    GNUPGHOME = "\"$XDG_DATA_HOME\"/gnupg";
    #xdg-ninja recommendations - end

  };
  environment.persistence."/state".users.rg.directories = [
    ".local/share/android"
    ".local/share/cargo"
    ".local/share/rustup"
  ];

  environment.persistence."/pst".users.rg.directories = [
    ".config/attic"
  ];

  users.users.rg.extraGroups = [ "kvm" ];
  hm.programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  hm.dconf.settings = {
    "org/gnome/pomodoro/preferences" = {
      enabled-plugins = [ "sounds" "notifications" "dark-theme" ];
      pomodoro-duration = 3120.0;
      short-break-duration = 1020.0;
      long-break-duration = 2040.0;
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

  hm.programs.lan-mouse.settings = {
    release_bind = [ "KeyA" "KeyS" "KeyD" "KeyF" ];
    port = 7742;
    frontend = "gtk";
    systemd = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      53317 # LocalSend (installed thru flatpak)
    ];
    allowedUDPPorts = [
      53317 #  LocalSend (installed thru flatpak)
    ];
  };

  environment.systemPackages = with pkgs; [
    agenix
    attic-client
    pamixer
    xdg-ninja
    mypkgs.flatpak-xdg-utils
    # handlrXdg
    nixpkgs-fmt
    unstable.yt-dlp

    #Gnome and related stuff
    gnome_pomodoro
    gnomeExtensions.appindicator # Try to fix tray icons (especially jellyfin-mpv-shim and udiskie2)
    gnome.seahorse
    gnome.file-roller
    gnome.nautilus
    loupe
    gparted
    pavucontrol
    pwvucontrol
    xorg.xlsclients
    xorg.xeyes
    #Utils
    yubikey-manager
    playerctl
    udiskie
    libqalculate
    ntfs3g
    steam-run
    ripgrep-all
    virt-manager
    udisks2
    riff

    # :eyes:
    # Too new a project. e.g, `rm` hangs on pipes created with mkfifo
    # (pkgs.uutils-coreutils.override { prefix = ""; })

    sonixd

    ventoy-bin
    libnotify
    nodePackages.prettier
    typst-lsp #for VSCode and such
  ];
}
