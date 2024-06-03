{ config, pkgs, ... }:

{

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];

  imports = [
    ../../modules/systemd-initrd.nix
    #Firefox through flatpak (testing)
    # ../../modules/workstation/firefox.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix

    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix

    #    ../../modules/hardware/nvidia.nix
    ../../modules/core/lanzaboote.nix
    #    ../../modules/core/hardening.nix
    #    ../../modules/libvirt.nix
    ../../modules/impermanence.nix
    ../../modules/docker.nix
    ../../modules/dei.nix
  ];

  services.zfs.expandOnBoot = "all";

  users.users.rg.extraGroups = [ "docker" ];

  rg = {
    #TODO: change
    ip = "192.168.10.1";
    #TODO: change
    machineId = "d50445fd8e8745c5abd3aadefb7f8af6";
    machineType = "amd";
    class = "workstation";
    #TODO: change
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlOwjvhd+yIUCNLtK4q3nNT3sZNa/CfPcvuxXMU02Fq";
  };

  # hm.home.packages = with pkgs; [ anki-bin ];

  environment.persistence."/state" = {
    # directories = [ ];
    users.rg = {
      files = [
      ];
      directories = [
        ".vscode"
        ".config/Code"
        ".m2"


      ];
    };
  };

  # boot.initrd.systemd.enable = true;

  environment.persistence."/pst" = {
    directories =
      [
        "/etc/NetworkManager/system-connections"
      ];
    users.rg = {
      directories = [
        ".config/dconf"
        ".config/safeeyes"
        "Documents"
        "Downloads"
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


  boot.initrd.systemd.emergencyAccess = true;
  boot.initrd.systemd.services.rollback = {
    description = "Rollback root filesystem to a pristine state on boot";
    wantedBy = [
      # "zfs.target"
      "initrd.target"
    ];
    after = [
      "zfs-import-zpool.service"
    ];
    before = [
      "sysroot.mount"
    ];
    path = with pkgs; [
      zfs
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zpool/local/root@blank && echo "  >> >> rollback complete << <<"
    '';
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

  #Additional packages
  environment.systemPackages = with pkgs; [
    appimage-run
    simple-scan
    lm_sensors
    colordiff
    gnome.gnome-tweaks
    easyeffects
  ];

  zramSwap.enable = true;

  hm.home.stateVersion = "24.05";
  system.stateVersion = "24.05";

}
