{ config, lib, ... }:
let
  hostname = config.networking.hostName;
  inherit (config.rg) ip;
  inherit (config.networking) fqdn;
  appName = "Gitea RG";
in
{

  systemd.services."caddy".serviceConfig.SupplementaryGroups = [ "gitea" ]; # For acme certificate

  services.caddy.virtualHosts."git.${fqdn}" = {
    useACMEHost = "rafael.ovh";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy unix//run/gitea/gitea.sock
    '';
  };

  services.gitea = {
    enable = true;
    stateDir = lib.mkDefault "/data/gitea";
    settings = {
      # actions.ENABLED = true;
      DEFAULT =
        {
          APP_NAME = appName;
        };
      mailer = {
        ENABLED = true;
        PROTOCOL = "sendmail";
      };
      ui = {
        AUTHOR = appName;
        DESCRIPTION = "${appName} - Git service";

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
        REQUIRE_SIGNIN_VIEW = true;
        DISABLE_REGISTRATION = true;

      };
      log.LEVEL = "Warn";
      server =
        let sshPort = 4222;
        in {
          BUILTIN_SSH_SERVER_USER = "git";
          PROTOCOL = "http+unix";
          ROOT_URL = "https://git.${fqdn}";
          # HTTP_ADDR = "127.0.0.1";
          SSH_PORT = sshPort;
          DOMAIN = hostname;
          SSH_LISTEN_HOST = ip;
          SSH_LISTEN_PORT = sshPort;
          START_SSH_SERVER = true;
          OFFLINE_MODE = true;
        };
    };
    dump = {
      enable = true;
      interval = "02:30";
      type = "tar.zst";
      #TODO: stop using hacky fixed dir
      backupDir = "/state/backups/gitea";
      file = "gitea-dump.tar.zst";
    };
  };
}
