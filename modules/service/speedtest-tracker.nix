{ config, ... }:
let
  inherit (config.rg) domain;
  cfg = config.services.speedtest-tracker;
  vhost = "speedtest.${domain}";
  appKeyFile = "${cfg.dataDir}/app-key";
in
{
  services.speedtest-tracker = {
    enable = true;
    virtualHost = vhost;
    settings = {
      APP_KEY_FILE = appKeyFile;
      APP_TIMEZONE = config.time.timeZone;
      DISPLAY_TIMEZONE = config.time.timeZone;
      SPEEDTEST_SCHEDULE = "0 */2 * * *";
      PRUNE_RESULTS_OLDER_THAN = 365;
    };
    poolConfig."listen.group" = config.services.caddy.group;
  };

  # Generated on first boot and persisted with the rest of dataDir; rotating it
  # invalidates sessions and encrypted settings.
  systemd.services.speedtest-tracker-setup.serviceConfig.ExecStartPre = [
    "/bin/sh -c '[ -s ${appKeyFile} ] || (umask 077; echo \"base64:$(head -c 32 /dev/urandom | base64)\" > ${appKeyFile})'"
  ];

  services.caddy.virtualHosts.${vhost} = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      root * ${cfg.package}/public
      php_fastcgi unix/${config.services.phpfpm.pools.speedtest-tracker.socket}
      file_server
    '';
  };

  environment.persistence."/pst".directories = [
    {
      directory = cfg.dataDir;
      inherit (cfg) user group;
      mode = "0710";
    }
  ];
}
