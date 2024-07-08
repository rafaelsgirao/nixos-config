{ config, pkgs, lib, hostSecretsDir, ... }:

let
  hostname = config.networking.hostName;
  hostnameUpper = lib.toUpper hostname;

  commonOpts = {
    rcloneConfigFile = config.age.secrets."rclone.conf".path;
    environmentFile = config.age.secrets.restic-env.path;
    passwordFile = config.age.secrets.restic-password.path;

    extraBackupArgs = [ "--exclude-caches" "--verbose" ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
      "--dry-run"
    ];
  };
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

  #Backups for servers
  services.restic.backups."${hostname}-oneDriveIST" = lib.mkIf (config.rg.class == "server") (commonOpts //
    {
      repository = "rclone:oneDriveIST:/Restic-Backups";
      timerConfig = {
        OnCalendar = "*-*-* 1:15:00";
        Persistent = true;
        RandomizedDelaySec = "5h";
      };

      backupCleanupCommand = lib.mkDefault "${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_${hostnameUpper}";

      paths = lib.mkDefault [
        "/pst"
        "/state/backups" #Backup files/dumps that are created by other tools & services, e.g postgresql, gitea, vaultwarden
      ];
      extraBackupArgs = [ "--exclude-caches" "--verbose" ];
    });

  #Backups for workstations
  services.restic.backups."onedriveIST" = lib.mkIf (config.rg.class == "workstation") (commonOpts //
    {
      timerConfig = null; #only run when explicitly started
      repository = "rclone:oneDriveIST:/Restic-Backups";
      # repositoryFile = "/state/backups/restic-repo";
      paths = lib.mkDefault [
        "/pst"
      ];

    });

}
