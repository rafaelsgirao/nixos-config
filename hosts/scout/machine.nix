{ config, pkgs, lib, ... }:

{

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];

  imports = [
    ../../modules/systemd-initrd.nix
    ../../modules/workstation/firefox.nix
    ../../modules/workstation/thunderbird.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix

    ../../modules/hardware/laptop.nix
    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix
    ../../modules/impermanence.nix
    ../../modules/docker.nix
    ../../modules/dei.nix
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  programs.gamemode.enable = true;

  services.zfs.expandOnBoot = "all";

  users.users.rg.extraGroups = [ "docker" "gamemode" ];

  rg = {
    ip = "192.168.10.1";
    machineId = "d50445fd8e8745c5abd3aadefb7f8af6";
    machineType = "intel";
    class = "workstation";
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlOwjvhd+yIUCNLtK4q3nNT3sZNa/CfPcvuxXMU02Fq";
    resetRootFs = true;
  };

  environment.persistence."/state" = {
    # directories = [ ];
    users.rg = {
      files = [
      ];
      directories = [
        ".local/share/fly"
        ".config/chromium"
        ".config/joplin-desktop"
        ".config/Joplin"
        ".local/share/ykman"
        ".local/share/Anki2"
        ".config/JetBrains"
        ".local/share/JetBrains"
        ".m2"
        #        ".local/share/Trash"  - Trashing on system internal mounts is not supported


      ];
    };
  };

  environment.persistence."/pst" = {
    directories =
      [
        "/etc/NetworkManager/system-connections"
      ];
    users.rg = {
      directories = [
        ".config/dconf"
        ".config/safeeyes"
        ".local/share/davisr"
        ".config/davisr"
        "Documents"
        "Downloads"
        ".config/monero-project"
        # I have a feeling impermanence files don't work that great... using folders for now.
        ".config/goa-1.0"
      ];
      files = [
        #see above comment
        # ".local/share/fish/fish_history"
        # ".local/share/zoxide/db.zo"
      ];
    };
  };

  nix.settings = {
    max-jobs = 4;
    cores = 6; # Thinkpad has 8 vCores, leave two for rest of the system
  };
  services.blocky.settings.blocking.clientGroupsBlock = {
    "127.0.0.1" = [ "normal" "rg" ];
  };

  #Blocky
  services.blocky.settings.customDNS.mapping = {
    "id.rafael.ovh" = "192.168.10.6";
  };


  environment.variables = {
    QEMU_OPTS =
      "-m 4096 -smp 4 -enable-kvm"; # https://github.com/NixOS/nixpkgs/issues/59219
  };


  #SSH daemon only inside Nebula
  services.openssh.listenAddresses = [{
    addr = config.rg.ip;
    port = 22;
  }];

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
    ffmpeg
    gcc
    # rustdesk
    appimage-run
    simple-scan
    lm_sensors
    colordiff
    monero-gui
    flyctl
    tor-browser-bundle-bin
    gnome.gnome-tweaks
    easyeffects
  ];

  zramSwap.enable = true;

  hm.home.stateVersion = "23.05";
  system.stateVersion = "23.05";

  hm.programs.lan-mouse = {
    enable = true;
    # package = inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Optional configuration in nix syntax, see config.toml for available options
    settings = {
      top = {
        # sazed
        activate_on_startup = false;
        ips = [ "192.168.10.5" ];
        port = 7742;
      };
    };
  };

  services.udev.extraRules = lib.mkIf (config.rg.class == "workstation") ''
    # DualShock 3 over USB
    KERNEL=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0666"

    # DualShock 3 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:0268*", MODE="0666"

  '';

}
