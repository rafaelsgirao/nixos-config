{ config, hostSecretsDir, lib, ... }:

let
  inherit (config.rg) domain;

in
{

  age.secrets.ENV-vaultwarden = {
    file = "${hostSecretsDir}/ENV-vaultwarden.age";
    mode = "440";
    owner = config.users.users.vaultwarden.name;
    group = config.users.groups.vaultwarden.name;
  };

  #Home as tmpfs.
  systemd.tmpfiles.rules = lib.mkIf (config.services.vaultwarden.backupDir != null) [
    "d /state/backups 0700 root root -"
    "d /state/backups/vaultwarden 0700 vaultwarden vaultwarden -"
  ];

  services.vaultwarden = {
    enable = true;
    backupDir = "/state/backups/vaultwarden";
    environmentFile = config.age.secrets.ENV-vaultwarden.path;
    config = {
      # DATA_FOLDER = "/persist/vaultwarden";
      DOMAIN = "https://vault.${domain}";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 52378;
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_ADDRESS = "127.0.0.1";
      WEBSOCKET_PORT = 3012;
      SIGNUPS_ALLOWED = false;
      SIGNUPS_VERIFY = true;
      SIGNUPS_DOMAINS_WHITELIST = domain;
      INVITATION_ORG_NAME = "RGVault";
      ICON_CACHE_TTL = "31536000";
      USE_SENDMAIL = true;
      SENDMAIL_COMMAND = "/run/wrappers/bin/sendmail";
      IP_HEADER = "X-Forwarded-For";

    };
  };
  systemd.services.backup-vaultwarden.serviceConfig = {
    UMask = "007";
  };
  environment.persistence."/pst".directories = [
    "/var/lib/bitwarden_rs"
  ];

  services.caddy.virtualHosts = {
    "vault.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        # Notifications redirected to the WebSocket server
        reverse_proxy /notifications/hub 127.0.0.1:3012

        reverse_proxy http://127.0.0.1:52378
      '';
    };
  };
}
