{
  config,
  pkgs,
  lib,
  ...
}:

{

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "i686-linux"
  ];

  imports = [
    ../../modules/systemd-initrd.nix
    ../../modules/core/lanzaboote.nix
    ../../modules/workstation/chromium.nix
    ../../modules/workstation/firefox.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix
    ../../modules/workstation/nextcloud-client.nix

    ../../modules/captive-portal.nix
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix
    ../../modules/impermanence.nix
    ../../modules/virt/podman.nix
    ../../modules/dei.nix
    ../../modules/restic.nix
    ../../modules/workstation/cosmic.nix
    ../../modules/workstation/cups.nix
  ];

  boot.kernelParams = [
    "mitigations=off"
    "thinkpad_acpi.force_load=1" # libreboot-recommended workaround
    "iomem=relaxed"
  ];
  hardware.bluetooth.input = {
    General = {
      ClassicBondedOnly = false;
      UserspaceHID = false;

    };
  };
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;

  users.users.rg.extraGroups = [
    "gamemode"
    "dialout"
  ];

  rg = {
    ip = "100.120.144.78";
    machineId = "cdc47ebb53e645aab6576d786aac1084";
    machineType = "intel";
    class = "workstation";
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRXa7/kHjUK8do4degCAvq1Ak2k3BGIn1kLYtjbQsjk root@vin";
    resetRootFs = true;
  };

  services.mullvad-vpn.enable = true;
  hardware.flipperzero.enable = true;
  environment.persistence."/state" = {
    # directories = [ ];
    users.rg = {
      files = [ ];
      directories = [
        ".local/share/fly"
        ".local/share/ykman"
        ".config/JetBrains"
        ".local/share/JetBrains"
        ".config/BraveSoftware"
        ".config/Mullvad VPN"
        ".m2"
      ];
    };
  };

  environment.persistence."/pst" = {
    directories = [ "/etc/NetworkManager/system-connections" ];
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
    cores = 6; # Dell Latitude has 8 vCores, leave two for rest of the system
  };

  # boot.crashDump.enable = true;

  boot.initrd.systemd.emergencyAccess = true;

  environment.variables = {
    QEMU_OPTS = "-m 4096 -smp 4 -enable-kvm"; # https://github.com/NixOS/nixpkgs/issues/59219
  };

  # Systemd timer so I go to sleep at decent hours
  # Thanks to abread on #JustNixThings https://discord.com/channels/759576132227694642/874345962515071026/923166110759677992
  systemd.services.go-to-bed = {
    serviceConfig.Type = "oneshot";
    path = [ pkgs.systemd ];
    script = ''
      #!/bin/sh
      # https://serverfault.com/a/1130371
      set -xu
      TIME=2200 # Desired time, in military time format
      DELTA=159 # Max delta
      MAXTIME=$((TIME + DELTA))
      NOW=$(date +%H%M)
      if [ "$NOW" -ge "$TIME" ] &&  [ "$NOW" -le "$MAXTIME" ]
      then
        poweroff
      fi
    '';
  };
  systemd.timers.go-to-bed-2200 = {
    wantedBy = [ "timers.target" ];
    partOf = [ "go-to-bed.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 21:59:59";
      Unit = "go-to-bed.service";
    };
  };

  #Additional packages
  environment.systemPackages = with pkgs; [
    ffmpeg
    gcc
    lm_sensors
    colordiff
    easyeffects
    # mypkgs.howdy
  ];

  zramSwap.enable = true;

  hm.home.stateVersion = "24.05";
  system.stateVersion = "24.05";

  hm.home.packages = with pkgs; [
    mullvad-vpn
    unstable.brave
    appimage-run
  ];

  # hm.programs.lan-mouse = {
  #   enable = false;
  #   # package = inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
  #   # Optional configuration in nix syntax, see config.toml for available options
  #   settings = {
  #     top = {
  #       # sazed
  #       activate_on_startup = false;
  #       ips = [ "192.168.10.5" ];
  #       port = 7742;
  #     };
  #   };
  # };

  # #Default sudo config + howdy config.
  # #Fingers crossed this won't bite me later...
  # security.pam.services.sudo.text = ''
  #   # Account management.
  #   account required pam_unix.so # unix (order 10900)
  #
  #   # Authentication management.
  #   auth sufficient pam_unix.so likeauth try_first_pass # unix (order 11500)
  #   auth required pam_deny.so # deny (order 12300)
  #
  #   # Password management.
  #   password sufficient pam_unix.so nullok yescrypt # unix (order 10200)
  #
  #   # Session management.
  #   session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
  #   session required pam_unix.so # unix (order 10200)
  #
  #   # Howdy config.
  #   auth sufficient pam_howdy.so
  #
  # '';
  services.udev.extraRules = lib.mkIf (config.rg.class == "workstation") ''
    # DualShock 3 over USB
    KERNEL=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0666"

    # DualShock 3 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:0268*", MODE="0666"

    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

}
