{
  config,
  pkgs,
  lib,
  secretsDir,
  ...
}:

let
  isWorkstation = config.rg.class == "workstation";
  inherit (lib) mkIf;

  hostname = config.networking.hostName;
  hostnameUpper = lib.toUpper hostname;
  provider = config.rg.backupsProvider;

  commonOpts = {
    rcloneConfigFile = config.age.secrets."rclone.conf".path;
    environmentFile = config.age.secrets.restic-env.path;
    passwordFile = config.age.secrets.restic-password.path;

    extraBackupArgs = [
      "--exclude-caches"
      "--verbose"
    ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
  };
in
{

  rg.backupsProvider = "storagebox";

  age.secrets = {
    "rclone.conf" = {
      file = "${secretsDir}/rclone-config.age";
      owner = mkIf isWorkstation "rg";
    };
    restic-env = {
      file = "${secretsDir}/restic-env.age";
    };
    restic-password = {
      file = "${secretsDir}/restic-password.age";
    };
  };

  #Backups for servers
  services.restic.backups."${provider}" =
    if (config.rg.class == "server") then
      (
        commonOpts
        // {
          repository = "rclone:${provider}:/Restic-Backups";
          timerConfig = {
            OnCalendar = "*-*-* 1:15:00";
            Persistent = true;
            RandomizedDelaySec = "5h";
          };

          backupCleanupCommand = lib.mkDefault "${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_RESTIC_${hostnameUpper}";

          paths = lib.mkDefault [
            "/pst"
            "/state/backups" # Backup files/dumps that are created by other tools & services, e.g postgresql, gitea, vaultwarden
            # TODO: deprecate this ^ in favor of /pst/backups.
          ];
          extraBackupArgs = [
            "--exclude-caches"
            "--one-file-system" # don't attempt to backup bindmounts and others.
            "--verbose"
          ];
        }
      )

    else
      #Backups for workstations
      (
        commonOpts
        // {
          timerConfig = null; # only run when explicitly started
          repository = "rclone:${provider}:/Restic-Backups";
          # repositoryFile = "/state/backups/restic-repo";
          paths = lib.mkDefault [ "/pst" ];

        }
      );

}
