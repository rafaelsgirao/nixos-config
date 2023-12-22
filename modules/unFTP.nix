{ config, pkgs, hostSecretsDir, ... }:
let
  rootDir = "/home/rg/Portal";
in
{
  age.secrets.unFTP-creds = {
    file = "${hostSecretsDir}/unFTP-creds.age";
    mode = "440";
    owner = "rg";
  };

  systemd.services.unftp = {
    after = [ "libvirtd.service" ];
    wantedBy = [ "network.target" ];
    environment = {
      UNFTP_AUTH_TYPE = "json";
      UNFTP_AUTH_JSON_PATH = config.age.secrets.unFTP-creds.path;
      UNFTP_BIND_ADDRESS = "${config.rg.ip}:2121";
      UNFTP_BIND_ADDRESS_HTTP = "127.0.0.1:52581";
      UNFTP_FAILED_LOGINS_POLICY = "user";
      UNFTP_ROOT_DIR = rootDir;
      UNFTP_PASSIVE_PORTS = "50000-51000";
    };
    serviceConfig = {
      # DynamicUser = true;
      User = "rg";
      ExecStart = "${pkgs.mypkgs.unFTP}/bin/unftp";

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "60s";

      #Hardening
      ProtectHome = "tmpfs";
      BindPaths = [ "${rootDir}" ];

      # CapabilityBoundingSet = [ "~CAP_SYS_ADMIN" ];
      RemoveIPC = true;
      CapabilityBoundingSet = [ "" ];
      SystemCallArchitectures = "native";
      SystemCallFilter =
        [ "~@reboot @privileged @obsolete @raw-io @mount @debug @cpu-emulation @resources" ];
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
      MemoryDenyWriteExecute = true;

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      RestrictSUIDSGID = true;
    };
  };
}
