{
  pkgs,
  lib,
  inputs,
  ...
}:
{

  # Jovian's overlay bumps gamescope's src to 3.16.24 but inherits the patch
  # from the base nixpkgs gamescope (prev.gamescope). Our system nixpkgs is
  # nixos-26.05, which ships gamescope 3.16.23 + a 3.16.23-shaped
  # shaders-path.patch that fails to apply to the 3.16.24 source ("Hunk #1
  # FAILED at 34"). Feed Jovian the unstable gamescope (already 3.16.24, with a
  # matching patch) as its base. mkBefore forces this overlay ahead of Jovian's
  # so its `prev.gamescope` (and the gamescope-wsi/wrapper derivations it builds
  # internally from that) all resolve to ours rather than the broken 26.05 one.
  nixpkgs.overlays = lib.mkBefore [
    (_final: prev: {
      gamescope = inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.gamescope;
    })
  ];

  imports = [
    # ../../modules/core/lanzaboote.nix

    ../../modules/workstation/chromium.nix
    ../../modules/workstation/default.nix
    ../../modules/workstation/gnome.nix
    ../../modules/workstation/flatpak.nix
    # ../../modules/workstation/nextcloud-client.nix
    # ../../modules/workstation/cosmic.nix
    # ../../modules/workstation/cups.nix

    ../../modules/hardware/laptop.nix
    ../../modules/hardware/uefi.nix
    ../../modules/hardware/zfs.nix
    ../../modules/hardware/zfs-unlock-initrd.nix
    ../../modules/hardware/tailscale-initrd.nix
    ../../modules/hardware/wifi-initrd.nix

    ../../modules/impermanence.nix
    ../../modules/virt/podman.nix
    # ../../modules/dei.nix
    ../../modules/restic.nix
  ];

  # Jupiter has no wired NIC and no keyboard, so the ZFS passphrase prompt is
  # only answerable over the network: wlan0 comes up in stage 1, tailscale rides
  # on it, and the unlock sshd listens on 2222.
  rg.zfsUnlockInitrd.wolInterfaces = [ ];

  rg.wifi-initrd = {
    enable = true;
    interface = "wlan0";
    kernelModules = [ "rtw88_8822ce" ];
    networks."Pingu" = "ext:psk_home";
  };

  # Stage 2 is on NetworkManager, so there is no networkd config to mirror into
  # the initrd; wpa_supplicant only associates, addressing happens here.
  boot.initrd.systemd.network = {
    enable = true;
    networks."10-wlan" = {
      matchConfig.Name = "wlan0";
      DHCP = "yes";
      # linkConfig.RequiredForOnline = "no";
    };
  };

  # Keeps the initrd wifi PSK and the initrd tailscale auth key (an OAuth client
  # secret) in place; boot.initrd.secrets appends both to the initrd at
  # bootloader install.
  age.secrets.WiFi-psk = {
    file = ../../secrets/jovian/WiFi-psk.age;
    path = "/pst/etc/ssh-initrd/wifi-psk";
    symlink = false;
  };

  age.secrets.Tailscale-initrd-authkey = {
    file = ../../secrets/jovian/Tailscale-initrd-authkey.age;
    path = "/pst/etc/ssh-initrd/tailscale-authkey";
    symlink = false;
  };

  boot.kernelParams = [
    "mitigations=off"
    # "thinkpad_acpi.force_load=1" # libreboot-recommended workaround
    "iomem=relaxed"
  ];

  programs.nix-ld.enable = true;
  jovian = {
    steam.enable = true;
    steam.autoStart = true;
    steam.user = "rg";
    steam.desktopSession = "gnome";
    devices.steamdeck.enable = true;
    hardware.has.amd.gpu = true;
    decky-loader.enable = true;
  };

  rg = {
    enableCosmic = false;
    machineId = "afed3fd3c2b7c4b8cfb823ec697e2efd";
    machineType = "amd";
    class = "workstation";
    resetRootFs = false;
  };

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

  # nix.settings = {
  #   max-jobs = 4;
  #   cores = 6; # Dell Latitude has 8 vCores, leave two for rest of the system
  # };

  # boot.crashDump.enable = true;

  boot.initrd.systemd.emergencyAccess = true;

  environment.variables = {
    QEMU_OPTS = "-m 4096 -smp 4 -enable-kvm"; # https://github.com/NixOS/nixpkgs/issues/59219
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

  hm.home.stateVersion = "25.11";
  system.stateVersion = "25.11";

  hm.home.packages = with pkgs; [
    unstable.brave
    appimage-run
    bitwarden-cli
  ];

}
