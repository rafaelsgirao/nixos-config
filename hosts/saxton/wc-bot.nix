{
  config,
  pkgs,
  hostSecretsDir,
  ...
}:

{
  users.groups.wc-bot-env = { };

  age.secrets.ENV-wc-bot = {
    file = "${hostSecretsDir}/ENV-WCBot.age";
    mode = "440";
    group = "wc-bot-env";
  };

  systemd.services.wc-bot = {
    after = [ "network.target" ];
    wantedBy = [ "network.target" ];
    environment = {
      NODE_ENV = "production";
      #Also define BOT_TOKEN.
    };
    serviceConfig = {
      DynamicUser = true;
      User = "wc-bot";
      ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.mypkgs.wc-bot}/lib/node_modules/ist-chan-bot/bot.js";

      EnvironmentFile = config.age.secrets.ENV-wc-bot.path;
      SupplementaryGroups = "wc-bot-env";

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
