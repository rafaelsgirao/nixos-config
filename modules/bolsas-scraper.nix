{ config, pkgs, hostSecretsDir, ... }:

let
  dir = "bolsas-scraper";
  fullDir = "/var/lib/private/${dir}";
in
{

  age.secrets.ENV-bolsas-scraper = {
    file = "${hostSecretsDir}/ENV-bolsas-scraper.age";
    # mode = " 440 ";
    group = "bolsas-scraper";
  };

  environment.persistence."/pst".directories = [ fullDir ];

  users.groups.bolsas-scraper = { };


  systemd.tmpfiles.rules = [
    "d /pst/site/ 0705 caddy caddy -"
    "d /pst/site/main/html 0705 caddy caddy -"
  ];

  #So caddy can read files from bolsas-scraper
  systemd.services."caddy".serviceConfig.supplementaryGroups = [ "bolsas-scraper" ];

  #Note to future self: this has to be on same machine that serves PDF archives
  # or else this will fail
  #TODO: DynamicUser here
  systemd.services.bolsas-scraper = {
    environment = {
      WORKDIR = fullDir;
      DOWNLOAD_PATH = "/pst/site/main/arquivo-bolsas";
    };
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "bolsas_scraper";
      StateDirectoryMode = "0700";
      Type = "oneshot";
      EnvironmentFile = config.age.secrets.ENV-bolsas-scraper.path;
      SupplementaryGroups = [ "bolsas-scraper" ];
    };
    script =
      "${pkgs.mypkgs.bolsas-scraper}/bin/bolsas-scraper && ${pkgs.curl}/bin/curl -fsS -m 10 -retry 5 -o /dev/null $HC_URL";
  };

  systemd.timers.bolsas-scraper-trigger = {
    wantedBy = [ "timers.target" ];
    partOf = [ "bolsas-scraper.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 07:30:00";
      Unit = "bolsas-scraper.service";
    };
  };

}
