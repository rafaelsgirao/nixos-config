{ pkgs, lib, ... }:
{

  imports = [
    ../../modules/firefox.nix
    ../../modules/graphical.nix
    # ../../modules/sway.nix
    ../../modules/lanzaboote.nix
    ../../modules/gnome.nix
    ../../modules/flatpak.nix

    # ../../modules/xorg.nix
    ../../modules/laptop.nix
    ../../modules/impermanence.nix
    ../../modules/zfs.nix
    ../../modules/dsi.nix
    ../../modules/syncthing.nix
    ../../modules/libvirt.nix
    # ../../modules/docker.nix
    #      ../../modules/nvidia.nix
    ../../modules/blocky.nix
    ../../modules/uefi.nix
    # Add configs later as needed
  ];

  services.zfs.expandOnBoot = "all";

  rg = {
    ip = "192.168.10.1";
    machineType = "intel";
    class = "workstation";
  };

  # hm.home.packages = with pkgs; [ anki-bin ];

  environment.persistence."/state" = {
    hideMounts = true;
    directories = [ ];
    users.rg = {
      files = [
      ];
      directories = [
        ".fly"
        ".vscode"
        ".config/Ferdium"
        ".config/chromium"
        ".mozilla"
        ".config/Sonixd"
        ".config/WebCord"
        "studymusic"
        ".local/share/ykman"
        ".local/share/Anki2"
        #        ".local/share/Trash"  - Trashing on system internal mounts is not supported


      ];
    };
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
      ];
    files = [ "/etc/machine-id" ];
    users.rg = {
      directories = [
        ".config/dconf"
        ".config/safeeyes"
        ".android"
        ".anydesk"
        ".thunderbird"
        ".local/share/davisr"
        "Music"
        "repos"
        "PX"
        "Pictures"
        "DSI"
        "Backups"
        "Downloads" # bah
        "Monero"
        # I have a feeling impermanence files don't work that great... using folders for now.
        ".config/Signal"
        ".config/goa-1.0"
      ];
      files = [
        #see above comment
        # ".local/share/fish/fish_history"
        # ".local/share/zoxide/db.zo"
      ];
    };
  };

  services.blocky.settings.blocking.clientGroupsBlock = {
    "127.0.0.1" = [ "normal" "rg" ];
  };

  #Blocky
  services.blocky.settings.customDNS.mapping = {
    "meerkat-mgmt.dsi.tecnico.ulisboa.pt" = "127.0.0.1";
    "id.rafael.ovh" = "192.168.10.6";
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r neonrgpool/local/root@blank
  '';

  environment.variables = {
    QEMU_OPTS =
      "-m 4096 -smp 4 -enable-kvm"; # https://github.com/NixOS/nixpkgs/issues/59219
  };

  networking = {
    hostId = "71b26626";
  };


  #SSH daemon only inside Nebula
  services.openssh.listenAddresses = [{
    addr = "192.168.10.1";
    port = 22;
  }];

  #Undervolt CPU
  services.undervolt.enable = true;
  services.undervolt.coreOffset = -80;

  # Systemd timer so I go to sleep at decent hours
  # Thanks to abread on #JustNixThings https://discord.com/channels/759576132227694642/874345962515071026/923166110759677992
  systemd.services.go-to-bed = {
    serviceConfig.Type = "oneshot";
    path = with pkgs; [ "systemd" ];
    script = "poweroff";
  };
  systemd.timers.go-to-bed-2200 = {
    wantedBy = [ "timers.target" ];
    partOf = [ "go-to-bed.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 21:59:59";
      Unit = "go-to-bed.service";
    };
  };
  systemd.timers.go-to-bed-2230 = {
    wantedBy = [ "timers.target" ];
    partOf = [ "go-to-bed.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 22:30..05:05";
      Unit = "go-to-bed.service";
    };
  };

  #Additional packages
  environment.systemPackages = with pkgs; [
    # autenticacao-gov
    #FIXME
    # remarkable-rcu
    ffmpeg
    gcc
    # rustdesk
    appimage-run
    simple-scan
    lm_sensors
    libreoffice
    poetry
    hyperfine
    colordiff
    #  ghidra-bin
    calibre
    monero-gui
    flyctl
    tor-browser-bundle-bin
    burpsuite
    gnome.gnome-tweaks
    unstable.webcord
    easyeffects
    #TODO: electronmail?
  ];

  zramSwap.enable = true;

  hm.home.stateVersion = "23.05";
  system.stateVersion = "23.05";

  programs.firejail.wrappedBinaries = {
    signal-desktop = {

      #TODO: signal-desktop.desktop
      executable = "${lib.getBin pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform=wayland";
      profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
    };
    jellyfinmediaplayer = {
      executable = "${pkgs.jellyfin-media-player}/bin/jellyfinmediaplayer";
      profile = pkgs.copyPathToStore ../../files/jellyfinmediaplayer.profile;
    };
  };

}
