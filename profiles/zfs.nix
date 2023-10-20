{ config, pkgs, lib, ... }: {
  #ZFS configs so pool works as root
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.initrd.supportedFilesystems = [ "zfs" ];
  #Use latest kernel + ZFS
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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
    interval = "2 weeks";
  };
  services.zfs.trim.enable = config.rg.machineType != "virt";
}
