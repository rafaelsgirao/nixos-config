{ lib, pkgs, ... }:

let
  RNLCert = builtins.fetchurl {
    url = "https://rnl.tecnico.ulisboa.pt/ca/cacert/cacert.pem";
    sha256 = "1jiqx6s86hlmpp8k2172ki6b2ayhr1hyr5g2d5vzs41rnva8bl63";
  };
in
{

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];

  imports = [
    # ../../modules/systemd-initrd.nix
    #Firefox through flatpak (testing)
    # Not using flatpaked firefox while this isn't solved:
    # https://github.com/flatpak/flatpak/issues/4525
    ../../modules/workstation/firefox.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix

    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/zfs-unlock.nix

    ../../modules/core/lanzaboote.nix
    #    ../../modules/core/hardening.nix
    #    ../../modules/libvirt.nix
    ../../modules/impermanence.nix
    ../../modules/docker.nix
  ];

  boot.kernelParams = [ "ip=193.136.164.205::193.136.164.222:255.255.255.224::eth0:none" ];
  services.zfs.expandOnBoot = "all";
  security.pki.certificateFiles = [ "${RNLCert}" ];
  users.users.rg.extraGroups = [ "docker" ];
  #To make VS Code remote SSH work without too much hassle/timesink
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;


  rg = {
    ip = "192.168.10.5";
    isLighthouse = false; #Local firewall doesn't allow world access to 4242.
    machineId = "4307a85c4d5e403fbd89fc34f27527e1";
    machineType = "amd";
    class = "workstation";
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL98QtOSOE5mmB/EXHsINd5mHc46gkynP2FBN939BlEc root@sazed";
  };

  environment.persistence."/state" = {
    # directories = [ ];
    users.rg = {
      files = [
      ];
      directories = [
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


  # boot.initrd.systemd.emergencyAccess = true;
  # boot.initrd.systemd.services.rollback = {
  #   description = "Rollback root filesystem to a pristine state on boot";
  #   wantedBy = [
  #     # "zfs.target"
  #     "initrd.target"
  #   ];
  #   after = [
  #     "zfs-import-zpool.service"
  #   ];
  #   before = [
  #     "sysroot.mount"
  #   ];
  #   path = with pkgs; [
  #     zfs
  #   ];
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     zfs rollback -r zpool/local/root@blank && echo "  >> >> rollback complete << <<"
  #   '';
  # };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r neonheavypool/local/root@blank
  '';

  environment.variables = {
    QEMU_OPTS =
      "-m 4096 -smp 4 -enable-kvm"; # https://github.com/NixOS/nixpkgs/issues/59219
  };

  #Additional packages
  environment.systemPackages = with pkgs; [
    appimage-run
    lm_sensors
    colordiff
    gnome.gnome-tweaks
    easyeffects
  ];

  services.xserver.displayManager.gdm.autoSuspend = false;

  #dconf settings
  hm = _: {
    home.stateVersion = "24.05";
    dconf.settings = {
      "org/gnome/desktop/a11y".always-show-universal-access-status = false;
      "org/gnome/desktop/interface".text-scaling-factor = 1.0;
    };
    programs.lan-mouse = {
      enable = true;
      # systemd = false;
      # package = inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
      # Optional configuration in nix syntax, see config.toml for available options
      settings = {
        bottom = {
          # scout
          activate_on_startup = true;
          ips = [ "192.168.10.1" ];
          port = 7742;
        };
      };
    };
  };

  zramSwap.enable = true;

  system.stateVersion = "24.05";
}
