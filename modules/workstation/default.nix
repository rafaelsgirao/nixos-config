{ config, lib, pkgs, ... }:
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
  # imports = [ ./chromium.nix ];
  # improve desktop responsiveness when updating the system
  nix.daemonCPUSchedPolicy = "idle";
  hm.programs.thunderbird = {
    enable = true;
    # package = null;
    profiles."rg" = {

      isDefault = true;
      settings = { };
    };
    settings =
      {
        "general.useragent.override" = "";
        "privacy.donottrackheader.enabled" = true;

      };
  };
  hm.accounts.email.accounts."rafael@rafael.ovh" = {
    userName = "rafael@rafael.ovh";
    address = "rafael@rafael.ovh";
    imap = {
      host = "mail.rafael.ovh";
      port = 44993; #default
      tls.enable = true;
    };
    #This... doesn't work. it just prompts me for the password on launch anyway
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email rafael@rafael.ovh";
    realName = "Rafael Girão";
    signature.text = ''
      Melhores Cumprimentos / Best Regards,
      Rafael Girão
    '';
    smtp = {
      host = "mail.rafael.ovh";
      port = 44465; #default
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
    };
  };

  hm.accounts.email.accounts."rg@rafael.ovh" = {
    primary = true;
    userName = "rg@rafael.ovh";
    address = "rg@rafael.ovh";
    imap = {
      host = "mx.rafael.ovh";
      port = 993; #default
      tls.enable = true;
    };
    #see above passwordCommand comment
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email rafael@rafael.ovh";
    realName = "Rafael Girão";
    signature.text = ''
      Melhores Cumprimentos / Best Regards,
      Rafael Girão
    '';
    smtp = {
      host = "mx.rafael.ovh";
      port = 465; #default
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
    };
  };
  hm.accounts.email.accounts."rafael.s.girao@tecnico.ulisboa.pt" = {
    # primary = true;
    userName = "ist199309";
    address = "rafael.s.girao@tecnico.ulisboa.pt";
    imap = {
      host = "mail.tecnico.ulisboa.pt";
      port = 993; #default
      tls.enable = true;
    };
    #see above passwordCommand comment
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email rafael.s.girao@tecnico.ulisboa.pt";
    realName = "Rafael Girão";
    signature.text = ''
      Melhores Cumprimentos / Best Regards,
      Rafael Girão
    '';
    smtp = {
      host = "mail.tecnico.ulisboa.pt";
      port = 465; #default
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
    };
  };

  # programs.kdeconnect = lib.mkIf (config.rg.class == "workstation") {
  #   enable = true;
  #   package = pkgs.gnomeExtensions.gsconnect;

  # };

  #Enable SSH agent on boot
  programs.ssh.startAgent = true;
  # services.teamviewer.enable = true;

  programs.noisetorch.enable = lib.mkIf (config.rg.machineType != "virt") true;

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
      name = "ePapirus-Dark";
    };
    cursorTheme = { name = "elementary"; };
  };

  # TAKEN FROM https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/intel/default.nix
  # ---
  hm.qt = {
    enable = true;
    platformTheme = "gtk";
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
      # mattermost = {
      #   name = "Mattermost DSI";
      #   # icon = "${configDir}/icons/Notion.png";
      #   exec = "${pre}/chromium --new-window --app=\"https:/chat.tecnico.ulisboa.pt\"";
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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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

  # nix.settings.autoOptimiseStore = true;

  #--------------------------------------------
  #--------------Yubikey Settings-------------
  #--------------------------------------------

  security.pam.u2f = {
    enable = false;
    control = "optional";
    cue = true;
  };

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
  #AppArmor is recommended for Firejail
  #Disable for now - https://github.com/NixOS/nixpkgs/issues/169056
  security.apparmor.enable = false;

  hm.programs.zathura = {
    enable = true;
    options = {
      recolor = "true";
      selection-clipboard = "clipboard";
      # sandbox = "none";
    };
  };

  hm.xdg = {
    userDirs.enable = true;
    enable = true;
    mime.enable = true;
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

  programs.firejail = {
    enable = true;
    wrappedBinaries =
      {
        # thunderbird = {
        #   executable = "${lib.getBin pkgs.thunderbird}/bin/thunderbird";
        #   # extraArgs = [ "--join-or-start=thunderbird" ];
        #   desktop = "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
        # };
        # chromium = {
        #   # executable = "${lib.getBin pkgs.ungoogled-chromium}/bin/chromium  --force-dark-mode --enable-features=WebUIDarkMode";
        #   executable = "${lib.getBin pkgs.ungoogled-chromium}/bin/chromium";
        #   # extraArgs = [ "--join-or-start=chromium" ];
        #   desktop = "${pkgs.ungoogled-chromium}/share/applications/firefox.desktop";
        # };
        # Tray icons are passed by files on /tmp, ignore private tmp on tray apps
        ferdium =
          let
            #NOTE: can't build ferdium from source b/c package-lock.json is missing. Suggested workarounds are cursed.
            ferdiumPkg = pkgs.ferdium;
          in
          {
            desktop = "${ferdiumPkg}/share/applications/ferdium.desktop";
            executable = "${lib.getBin ferdiumPkg}/bin/ferdium"; # --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer";
            profile = pkgs.writeText "ferdium.profile" ''
              ignore private-tmp
              include ${pkgs.copyPathToStore ../../files/ferdium.profile}
            '';
          };
        anydesk = {
          executable = "${lib.getBin pkgs.anydesk}/bin/anydesk";
          desktop = "${pkgs.anydesk}/share/applications/AnyDesk.desktop";
          # extraArgs = [ "--join-or-start=anydesk" ];
        };
      };
  };

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

  hm.programs.vscode =
    let
      p = pkgs.unstable;
    in
    {
      enable = true;
      package = p.vscode;

      # userSettings = {
      #   "workbench.colorTheme" = "Catppuccin Macchiato";
      #   "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace'";
      #   "python.languageServer" = "Jedi";
      #   "dummy" = "${pkgs.python3Packages.jedi-language-server}"; #Dummy comment so this package is pulled into VSCode's scope.
      # };

      # mutableExtensionsDir = false;

      extensions = with p.vscode-extensions;
        [
          #Jupyter
          ms-toolsai.jupyter
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.jupyter-renderers
          ms-toolsai.jupyter-keymap
          # ms-vscode.cpptools
          llvm-vs-code-extensions.vscode-clangd
          ms-vscode.makefile-tools
          matklad.rust-analyzer
          eamodio.gitlens
          wakatime.vscode-wakatime

          bbenoist.nix #  Nix lang support
          # ms-python.vscode-pylance
          ms-python.python
          bradlc.vscode-tailwindcss
          # ms-vsliveshare.vsliveshare
          usernamehw.errorlens
          catppuccin.catppuccin-vsc
          ritwickdey.liveserver

          nvarner.typst-lsp
          mgt19937.typst-preview
          mkhl.direnv

          # ];
        ] ++ p.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "vscode-pdf";
          publisher = "mathematic";
          version = "0.0.6";
          sha256 = "sha256-I4y1tzktH4wvD+g4CPeVpqA0S2ZgQ7KyDy6k2Ao4HKU=";
        }] ++ p.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "ruff";
          publisher = "charliermarsh";
          version = "2023.12.0";
          sha256 = "sha256-si1957iq3Wx5WawJ5JqtgpENE+RcdA279fOQ00XjAjk=";

        }] ++ p.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "codetogether";
          publisher = "genuitecllc";
          version = "2023.1.1";
          sha256 = "sha256-9XcnsrC3wUo721ldBwT2ZAHaslwHqN1i4tkSbt3OV2I=";
        }];
    };

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

  programs.nix-index = {
    enable = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
  # environment.persistence."/state".users.rg.directories = lib.mkIf isWorkstation [
  #   ".cache"
  #   ".cargo"
  #   ".rustup"
  #   ".cert"
  # ];

  environment.systemPackages = with pkgs; [
    pamixer
    # xdg-utils
    mypkgs.flatpak-xdg-utils
    # handlrXdg
    nixpkgs-fmt
    nixfmt

    #Gnome and related stuff
    gnome.pomodoro
    gnomeExtensions.appindicator # Try to fix tray icons (especially jellyfin-mpv-shim and udiskie2)
    gnome.seahorse
    gnome.file-roller
    gnome3.eog
    cinnamon.nemo
    gparted
    pavucontrol
    xorg.xlsclients
    xorg.xeyes
    #Utils
    rustup
    # rofi
    yubikey-manager
    playerctl
    udiskie
    libqalculate
    ntfs3g
    steam-run
    gdb
    pandoc
    ripgrep-all
    virt-manager
    nodePackages.tailwindcss
    udisks2
    riff

    # :eyes:
    # Too new a project. e.g, `rm` hangs on pipes created with mkfifo
    # (pkgs.uutils-coreutils.override { prefix = ""; })

    sonixd
    joplin-desktop
    sox # Used to generate brown noise

    ventoy-bin
    libnotify
    nodePackages.prettier
    typst-lsp #for VSCode and such
    yubioath-flutter
  ];
}
