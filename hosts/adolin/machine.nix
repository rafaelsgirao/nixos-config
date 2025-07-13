{
  pkgs,
  ...
}:

{

  imports = [
    ../../modules/systemd-initrd.nix
    #    ../../modules/core/lanzaboote.nix
    ../../modules/workstation/chromium.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix
    ../../modules/workstation/nextcloud-client.nix

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
  ];

  programs.nix-ld.enable = true;

  users.users.rg.extraGroups = [
    "dialout"
  ];

  rg = {
    ip = "100.120.144.78"; # TODO wrong
    machineId = "cdc47ebb53e645aab6576d786aac1084"; # TODO wrong
    machineType = "intel";
    class = "workstation";
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRXa7/kHjUK8do4degCAvq1Ak2k3BGIn1kLYtjbQsjk root@vin"; # TODO wrong
    resetRootFs = true;
  };

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
        ".m2"
      ];
    };
  };

  environment.persistence."/pst" = {
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
  ];

  zramSwap.enable = true;

  hm.home.stateVersion = "24.11";
  system.stateVersion = "24.11";

  hm.home.packages = with pkgs; [
    unstable.brave
    appimage-run
  ];
}
