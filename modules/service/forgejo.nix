{ config, ... }:
let
  hostname = config.networking.hostName;
  inherit (config.rg) ip;
  inherit (config.networking) fqdn domain;
  appName = "Forgejo RG";
  backupDir = "/pst/backups/forgejo";
  baseDir = "/var/lib/forgejo";
  listenAddr = config.services.forgejo.settings.server.HTTP_ADDR;
in
{

  systemd.services."caddy".serviceConfig.SupplementaryGroups = [ "forgejo" ]; # For acme certificate

  services.caddy.virtualHosts."forgejo.${fqdn}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy unix/${listenAddr}
    '';
  };

  environment.persistence."/pst".directories = [ "${baseDir}" ];

  services.forgejo = {
    enable = true;
    stateDir = "${baseDir}";
    # NixOS service is smart and takes care of the rest if database.type is set.
    database.type = "postgres";
    dump = {
      enable = true;
      interval = "02:30";
      type = "tar.zst";
      inherit backupDir;
      file = "forgejo-dump.tar.zst";
    };
    settings = {
      DEFAULT = {
        APP_NAME = appName;
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "sendmail";
      };
      ui = {
        AUTHOR = appName;
        DESCRIPTION = "${appName}";
      };
      session = {
        COOKIE_SECURE = true;
      };
      repository = {
        DISABLE_STARS = true;
      };
      migrations = {
        ALLOW_LOCALNETWORKS = true;
      };
      security = {
        INSTALL_LOCK = true;
      };
      service = {
        REQUIRE_SIGNIN_VIEW = false;
        DISABLE_REGISTRATION = true;
      };
      log.LEVEL = "Warn";
      server =
        let
          sshPort = 4222;
        in
        {
          BUILTIN_SSH_SERVER_USER = "git";
          PROTOCOL = "http+unix";
          ROOT_URL = "https://git.${domain}";
          SSH_PORT = sshPort;
          DOMAIN = hostname;
          SSH_LISTEN_HOST = ip;
          SSH_LISTEN_PORT = sshPort;
          START_SSH_SERVER = true;
          OFFLINE_MODE = true;
        };
    };
  };
}
