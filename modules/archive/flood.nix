{
  config,
  pkgs,
  hostSecretsDir,
  ...
}:

{

  users.groups.flood-ui-env = { };

  age.secrets.ENV-flood-ui = {
    file = "${hostSecretsDir}/ENV-flood-ui.age";
    mode = "440";
    group = "flood-ui-env";
  };

  systemd.services.flood-ui = {
    #FIXME: fix flood-ui (doesn't work ATM), then reenable these lines
    # after = [ "network.target" ];
    # wantedBy = [ "network.target" ];
    environment = {
      FLOOD_OPTION_port = "39629";
      FLOOD_OPTION_rundir = "/run/flood-ui";
      FLOOD_OPTION_trurl = "https://transmission.spy.rafael.ovh";
      FLOOD_OPTION_allowedpath = "/library/downloads";
      #      FLOOD_OPTION_truser 
      #      FLOOD_OPTION_trpass 
    };
    serviceConfig = {
      RuntimeDirectory = "flood-ui";
      DynamicUser = true;
      User = "flood-ui";
      SupplementaryGroups = "flood-ui-env";
      EnvironmentFile = config.age.secrets.ENV-flood-ui.path;

      ExecStart = "${pkgs.flood}/bin/flood";

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "10s";

      #Hardening
      CapabilityBoundingSet = [ "" ];
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "~@reboot @privileged @obsolete @raw-io @mount @debug @cpu-emulation" ];
      PrivateDevices = true;
      PrivateIPC = true;
      ProtectProc = "invisible";
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectHostname = true;
      ProtectClock = true;
      RestrictAddressFamilies = [ "AF_INET AF_INET6 AF_UNIX" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      PrivateUsers = true;
      ProtectControlGroups = true;
      ProcSubset = "pid";
      LockPersonality = true;
      # MemoryDenyWriteExecute = true; # Prowlarr (Dotnet?) requires not using this
      #Otherwise it fails with a message, regarding CoreCLR
      ProtectHome = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      RestrictSUIDSGID = true;
    };
  };
}
