{ config, pkgs, hostSecretsDir, ... }:

{

  age.secrets.ENV-bolsas-scraper = {
    file = "${hostSecretsDir}/ENV-bolsas-scraper.age";
    # mode = " 440 ";
    # group = "hc-alive";
  };

  #Note to future self: this has to be on same machine that serves PDF archives
  # or else this will fail
  #TODO: DynamicUser here
  systemd.services.bolsas-scraper = {
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.age.secrets.ENV-bolsas-scraper.path;
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
