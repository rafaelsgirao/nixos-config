# https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2

{
  config,
  lib,
  pkgs,
  ...
}:
let
  isEnabled = config.rg.resetRootFs;
  isSystemdInitrd = config.boot.initrd.systemd.enable;
  script = ''
    zfs rollback -r zpool/local/root@blank && echo "  >> >> rollback complete << <<"
  '';
  poolName = config.rg.resetRootFsPoolName;
in
{
  #Legacy initrd version.
  boot.initrd.postDeviceCommands = lib.mkIf (isEnabled && !isSystemdInitrd) (
    lib.mkAfter ''
      zfs rollback -r ${poolName}/local/root@blank
    ''
  );

  # systemd-initrd version.
  boot.initrd.systemd.services.rollback = lib.mkIf (isEnabled && isSystemdInitrd) {
    description = "Rollback root filesystem to a pristine state on boot";
    wantedBy = [
      # "zfs.target"
      "initrd.target"
    ];
    after = [ "zfs-import-${poolName}.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    inherit script;
  };
}
