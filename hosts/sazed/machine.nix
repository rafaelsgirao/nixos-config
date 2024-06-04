{ pkgs, ... }:

let
  RNLCert = builtins.fetchurl {
    url = "https://rnl.tecnico.ulisboa.pt/ca/cacert/cacert.pem";
    sha256 = "1jiqx6s86hlmpp8k2172ki6b2ayhr1hyr5g2d5vzs41rnva8bl63";
  };
in
{

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];

  imports = [
    ../../modules/systemd-initrd.nix
    #Firefox through flatpak (testing)
    # Not using flatpaked firefox while this isn't solved:
    # https://github.com/flatpak/flatpak/issues/4525
    ../../modules/workstation/firefox.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix

    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix

    #   ../../modules/core/lanzaboote.nix
    #    ../../modules/core/hardening.nix
    #    ../../modules/libvirt.nix
    ../../modules/impermanence.nix
    ../../modules/docker.nix
  ];

  services.zfs.expandOnBoot = "all";
  security.pki.certificateFiles = [ "${RNLCert}" ];
  users.users.rg.extraGroups = [ "docker" ];

  rg = {
    ip = "192.168.10.5";
    machineId = "4307a85c4d5e403fbd89fc34f27527e1";
    machineType = "amd";
    class = "workstation";
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL98QtOSOE5mmB/EXHsINd5mHc46gkynP2FBN939BlEc root@sazed";
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
