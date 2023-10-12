{ pkgs, config, hostSecretsDir, ... }: {

  age.secrets.HC-alive = {
    file = "${hostSecretsDir}/HC-alive.age";
    mode = "440";
    group = "hc-alive-env";

  };

  users.groups.hc-alive-env = { };

  systemd.services.healthchecks-alive = {
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      User = "hc-alive";
      SupplementaryGroups = "hc-alive-env";
      ReadOnlyPaths = [ config.age.secrets.HC-alive.path ];
      ProtectSystem = "strict";
      ExecStart =
        "${pkgs.bash}/bin/bash -c '${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $(${pkgs.coreutils}/bin/cat ${config.age.secrets.HC-alive.path})'";
    };
  };

  systemd.timers.healthchecks-alive = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # OnCalendar = "* * * * *";
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
    };
  };
}
