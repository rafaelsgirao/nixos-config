{
  pkgs,
  ...
}:
{

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

    ../../modules/impermanence.nix
    ../../modules/virt/podman.nix
    # ../../modules/dei.nix
    ../../modules/restic.nix
  ];

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
    unstable.citrix_workspace
    bitwarden-cli
  ];

}
