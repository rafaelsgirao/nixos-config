{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/firefox.nix
    ../../modules/graphical.nix
    ../../modules/healthchecks.nix
    ../../modules/gnome.nix
    ../../modules/lanzaboote.nix
    ../../modules/zfs.nix
    ../../modules/zfs-unlock.nix
    ../../modules/dsi.nix
    ../../modules/syncthing.nix
    ../../modules/libvirt.nix
    ../../modules/blocky.nix
    ../../modules/hardware/uefi.nix
    ../../modules/sshguard.nix
    ../../modules/flatpak.nix
    ../../modules/impermanence.nix
    # Add configs later as needed
  ];
  #
  # https://discourse.nixos.org/t/conditionally-import-module-if-it-exists/17832/2
  # imports = [ … ] ++ lib.optional (builtins.pathExists ./secrets.nix) ./secrets.nix;

  rg = {
    ip = "192.168.10.5";
    machineType = "intel";
    class = "workstation";
  };

  hm.home.stateVersion = "23.05";
  system.stateVersion = "23.05";

  networking.interfaces.eth0.wakeOnLan.enable = true;

  # environment.persistence."/pst" = {
  #   directories =
  #     # [
  #     # ];
  #   # files = [ "/etc/machine-id" ];
  #   users.rg.directories = [];
  # };

  services.blocky.settings.conditional.mapping = {
    "tecnico.ulisboa.pt" = "193.136.152.81,193.136.152.82";
    "ist.utl.pt" = "193.136.152.81,193.136.152.82";
  };

  #TODO: uncomment dis
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r medicpool/local/root@blank
  '';

  services.xserver.displayManager.gdm.autoSuspend = false;

  environment.variables = {
    QEMU_OPTS =
      "-m 4096 -smp 4 -enable-kvm"; # https://github.com/NixOS/nixpkgs/issues/59219
  };

  programs.git.config.user.email = "rafael.s.girao@tecnico.ulisboa.pt";

  services.zfs.trim.enable = true;

  networking = {
    hostName = "medic";
    hostId = "71b26626";
  };

  networking.firewall.allowedTCPPorts = [
    4242 # Nebula lighthouse
  ];
  networking.firewall.allowedUDPPorts = [
    9 #Wake-on-LAN (debugging, actual wake-on-lan doesn't care about firewall)
    4242 # Nebula lighthouse
  ];


  services.nebula.networks."rgnet" = {
    isLighthouse = true;
    lighthouses = [ ];
  };

  #ZFS Remote unlocking
  boot.kernelParams =
    [ "ip=193.136.132.93::193.136.132.254:255.255.255.0::eth0:none" ];

  #Additional packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    libreoffice
    poetry
    hyperfine
    colordiff
  ];

  zramSwap.enable = true;

}
