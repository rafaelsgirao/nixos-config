{
  config,
  pkgs,
  hostSecretsDir,
  ...
}:

let
  dir = "bolsas-scraper";
  stateDir = "/var/lib/${dir}";
  DLDir = "/pst/site/main/arquivo-bolsas/";
in
{

  age.secrets.ENV-bolsas-scraper = {
    file = "${hostSecretsDir}/ENV-bolsas-scraper.age";
    mode = " 440 ";
    owner = "bolsas-scraper";
  };

  environment.persistence."/pst".directories = [
    {
      directory = stateDir;
      user = "bolsas-scraper";
      group = "bolsas-scraper";
      mode = "700";
    }
  ];

  users.groups.bolsas-scraper = { };

  users.users = {
    bolsas-scraper = {
      group = "bolsas-scraper";
      extraGroups = [ "caddy" ];
      isSystemUser = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /pst/site/ 0550 caddy caddy -"
    "d /pst/site/main 0550 caddy caddy -"
    "d ${DLDir} 0750 bolsas-scraper caddy -"
  ];

  #So caddy can read files from bolsas-scraper
  # systemd.services."caddy".serviceConfig.supplementaryGroups = [ "bolsas-scraper" ];

  #Note to future self: this has to be on same machine that serves PDF archives
  # or else this will fail
  #TODO: DynamicUser here
  systemd.services.bolsas-scraper = {
    environment = {
      WORKDIR = stateDir;
      DOWNLOAD_PATH = DLDir;
    };
    serviceConfig = {
      User = "bolsas-scraper";
      StateDirectory = dir;
      StateDirectoryMode = "0700";
      Type = "oneshot";

      EnvironmentFile = config.age.secrets.ENV-bolsas-scraper.path;
    };
    script = "${pkgs.mypkgs.bolsas-scraper}/bin/bolsas-scraper && ${pkgs.curl}/bin/curl -fsS -m 10 -retry 5 -o /dev/null $HC_URL";
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
