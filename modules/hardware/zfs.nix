{
  config,
  pkgs,
  lib,
  ...
}:
let
  poolName = config.rg.resetRootFsPoolName;
in

{
  imports = [ ./reset-rootfs.nix ];
  #ZFS configs so pool works as root
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.initrd.supportedFilesystems = [ "zfs" ];
  virtualisation.docker.storageDriver = "zfs";

  services.zfs.zed.settings = {
    ZFS_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "root" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";
    ZED_NOTIFY_INTERVAL_SECS = 3600;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_NOTIFY_VERBOSE = true;
  };
  # Using this option would require recompiling ZFS w/ mail support https://nixos.wiki/wiki/ZFS#Mail_notification_for_ZFS_Event_Daemon
  # Instead, we add mail notifications w/ an alternative method above
  services.zfs.zed.enableMail = false;

  services.zfs.autoScrub = lib.mkIf (config.rg.machineType != "virt") {
    enable = true;
    # Want to do every 2 weeks but systemd does not support this easily (:
    # https://github.com/systemd/systemd/issues/6024
    interval = "monthly";
  };
  services.zfs.trim.enable = config.rg.machineType != "virt";

  # auto snapshots.
  services.sanoid = {
    enable = true;
    interval = "hourly";

    templates.data = {
      monthly = 12;
      daily = 15;
      yearly = 50;

      autoprune = true;
      autosnap = true;
    };

    datasets."${poolName}/safe" = {
      useTemplate = [ "data" ];
      recursive = true;
    };
  };
}
