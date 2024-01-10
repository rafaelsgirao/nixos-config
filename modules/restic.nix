{ config, pkgs, lib, hostSecretsDir, ... }:

let
  hostname = config.networking.hostName;
  hostnameUpper = lib.toUpper hostname;
in
{

  age.secrets = {
    "rclone.conf" = {
      file = "${hostSecretsDir}/../rclone-config.age";
    };
    restic-env = {
      file = "${hostSecretsDir}/../restic-env.age";
    };
    restic-password = {
      file = "${hostSecretsDir}/../restic-password.age";
    };
  };

  services.restic.backups."${hostname}-oneDriveIST" = {
    user = "root";
    repository = "rclone:oneDriveIST:/Restic-Backups";
    timerConfig = {
      OnCalendar = "*-*-* 1:15:00";
      Persistent = true;
      RandomizedDelaySec = "5h";
    };
    rcloneConfigFile = config.age.secrets."rclone.conf".path;
    environmentFile = config.age.secrets.restic-env.path;
    passwordFile = config.age.secrets.restic-password.path;

    backupCleanupCommand = lib.mkDefault "${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_${hostnameUpper}";

    paths = lib.mkDefault [
      "/pst"
      "/state/backups"
    ];
    extraBackupArgs = [ "--exclude-caches" "--verbose" ];
  };

}
