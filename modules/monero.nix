{ config, ... }:
let
  dataDir = "/var/lib/monero";
in
{
  networking.firewall = {
    allowedTCPPorts = [
      18080 # Monero
    ];
    allowedUDPPorts = [
      18080 # Monero
    ];
  };

  services.monero = {
    enable = true;
    inherit dataDir;
    rpc = {
      restricted = true;
      port = 18081;
      address = config.rg.ip;
    };
    limits = rec {
      download = 12500;
      upload = download;
    };
    extraConfig = ''
      no-zmq=1
      db-sync-mode=fastest:async:250000000bytes
      out-peers=256
      in-peers=128             # The default is unlimited; we prefer to put a cap on this
      confirm-external-bind=1
      # db-sync-mode=fastest:sync:8750
      # db-sync-mode=safe
    '';
  };
  systemd.services.monero.serviceConfig = {
    CapabilityBoundingSet = [ "" ];
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "~@reboot @privileged @obsolete @raw-io @mount @debug @cpu-emulation" ];
    PrivateDevices = true;
    RemoveIPC = true;
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
    # MemoryDenyWriteExecute = true; mprotect() syscall fails. see if it works w/o this...
    ProtectHome = true;
    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectSystem = "strict";
    ReadWritePaths = [ "${dataDir}" ];
    RestrictSUIDSGID = true;
    # https://unix.stackexchange.com/questions/494843/how-to-limit-a-systemd-service-to-play-nice-with-the-cpu
    # Default weight is 100.
    CPUWeight = "80";
    IOWeight = "20";
    MemorySwapMax = "0";

  };

}
