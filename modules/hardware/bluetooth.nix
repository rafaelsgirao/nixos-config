_:
{
  #Bluetooth.
  environment.persistence."/pst".directories = [
    "/var/lib/bluetooth"
  ];

  #Enable bluetooth
  hardware.bluetooth.enable = true;
  systemd.services."bluetooth".serviceConfig = {
    RestrictAddressFamilies = [ "AF_UNIX AF_BLUETOOTH" ];
    IPAddressDeny = "any";

    ProtectProc = "ptraceable";
    ProcSubset = "pid";
    # DevicePolicy = "clos
    # ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectHostname = true;
    ProtectClock = true;
    RestrictNamespaces = true;
    LockPersonality = true;
    RestrictSUIDSGID = true;
    NoNewPrivileges = true;

    SystemCallFilter = [ "@system-service" "~@resources @privileged" ];

    SystemCallArchitecture = "native";
  };
}
