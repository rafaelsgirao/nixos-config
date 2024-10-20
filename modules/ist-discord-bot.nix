{
  config,
  pkgs,
  hostSecretsDir,
  ...
}:

let
  stateDir = "/var/lib/ist-discord-bot";
in
{

  age.secrets.ENV-ist-discord-bot = {
    file = "${hostSecretsDir}/ENV-ist-discord-bot.age";
    mode = "400";
    owner = "ist-discord-bot";
  };

  environment.persistence."/pst".directories = [
    {
      directory = stateDir;
      user = "ist-discord-bot";
      group = "ist-discord-bot";
      mode = "700";
    }
  ];

  users.groups.ist-discord-bot = { };

  users.users = {
    ist-discord-bot = {
      group = "ist-discord-bot";
      isSystemUser = true;
    };
  };

  systemd.services.ist-discord-bot = {
    # after = [ "network.target" ];
    # wantedBy = [ "network.target" ];
    environment = {
      NODE_ENV = "production";
      DATABASE_URL = "file:${stateDir}/bot.db";
    };
    serviceConfig = {
      User = "ist-discord-bot";
      ExecStart = "${pkgs.mypkgs.ist-discord-bot}/bin/ist-discord-bot";
      StateDirectory = "ist-discord-bot";
      StateDirectoryMode = "0700";
      EnvironmentFile = config.age.secrets.ENV-ist-discord-bot.path;

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "5s";

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
      # MemoryDenyWriteExecute = true;
      ProtectHome = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      RestrictSUIDSGID = true;
    };
  };
}
