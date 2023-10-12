{ config, pkgs, hostSecretsDir, ... }:

let
  user = "sirpt-dnsbl";
  group = "sirpt-dnsbl";
  dataDir = "/data/sirpt-feed/data";
  outFile = "/data/sirpt-feed/sirpt-dnsbl.txt";
in
{

  age.secrets.sirpt-dnsbl = {
    file = "${hostSecretsDir}/ENV-sirptDNSBL.age";
    mode = "440";
    owner = user;
  };

  users.users = {
    sirpt-dnsbl = {
      inherit group;
      isSystemUser = true;
    };
  };

  users.groups.sirpt-dnsbl = { };

  systemd.services.sirpt-dnsbl =
    {
      restartIfChanged = false;
      serviceConfig = {
        Type = "oneshot";
        # DynamicUser = true;
        User = user;
        Group = group;

        EnvironmentFile = config.age.secrets.sirpt-dnsbl.path;
        # SupplementaryGroups = "sirpt-dnsbl-env";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";
        ReadWritePaths = [ dataDir ];
      };
      environment = {
        DATA_DIR = dataDir;
        OUT_FILE = outFile;
      };
      script =
        "${pkgs.sirpt-dnsbl}/bin/gen-dnsbl && ${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $HC_URL";
      postStop = "${pkgs.blocky}/bin/blocky refresh";
    };

  systemd.timers.sirpt-dnsbl-trigger = {
    wantedBy = [ "timers.target" ];
    partOf = [ "sirpt-dnsbl.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 07:00:00";
      Unit = "sirpt-dnsbl.service";
    };
  };

}
