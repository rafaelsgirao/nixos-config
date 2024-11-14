{ pkgs, ... }:
{

  # age.secrets.HC-alive = {
  #   file = "${hostSecretsDir}/HC-alive.age";
  #   mode = "440";
  #   group = "hc-alive-env";
  #
  # };
  #
  # users.groups.hc-alive-env = { };

  systemd.services.noisedropper = {
    # after = [ "network.target" ];     
    restartIfChanged = true;
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      # User = "hc-alive";
      # SupplementaryGroups = "hc-alive-env";
      # ReadOnlyPaths = [ config.age.secrets.HC-alive.path ];
      ProtectSystem = "strict";
      # AmbientCapabilities appear to not be enough :/
      ExecStart = "+${pkgs.mypkgs.noisedropper}/bin/noisedropper";
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_SYS_ADMIN"
      ];
      StateDirectory = "noisedropper";
    };
  };

  systemd.timers.noisedropper = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnStartupSec = "1min";
      OnUnitActiveSec = "24h";
    };
  };

  environment.systemPackages = [ pkgs.ipset ];

  environment.persistence."/state".directories = [
    {
      directory = "/var/lib/private/noisedropper";
      mode = "0700";
    } # service is DynamicUser
  ];
}
