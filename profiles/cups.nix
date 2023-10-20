_: {
  #Enable CUPS to print documents.
  services.printing = {
    enable = true;
    # drivers = [
    #   pkgs.hplip
    #   # pkgs.cnijfilter2 #IPPEverywhere just works!
    # ];
  };

  # From https://github.com/krathalan/systemd-sandboxing/blob/master/org.cups.cupsd.service.d/hardening.conf
  systemd.services."cups".serviceConfig = {
    #WARNING: Cups won't start if woken up from socket!
    # One of these configs is doing that, tho I can't bother rn.
    # IPAddressDeny = "any";
    # IPAddressAllow = [ "localhost" "192.168.10.0/24" ];
    # ProtectHome = true;
    # ProtectSystem = "strict";
    # ReadWritePaths = [ "-/etc/cups -/etc/printcap -/var/cache/cups -/var/spool/cups" ];
    # LogsDirectory = "cups";
    # NoNewPrivileges = true;
    # ProtectProc = "invisible";
    # ProcSubset = "pid";
    # # RuntimeDirectory = "cups";
    # PrivateTmp = true;

    # ProtectKernelTunables = true;
    # ProtectKernelModules = true;
    # ProtectKernelLogs = true;
    # CapabilityBoundingSet = [ "CapabilityBoundingSet=CAP_CHOWN CAP_AUDIT_WRITE CAP_DAC_OVERRIDE CAP_FSETID CAP_KILL CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID" ];
    # ProtectHostname = true;
    # ProtectClock = true;
    # ProtectControlGroups = true; # breaks cups ("Unable to change group for "/etc/cups/subscriptions.conf.N": Operation not permitted")
    # RestrictNamespaces = true;
    # LockPersonality = true;
    # MemoryDenyWriteExecute = true;
    # RestrictRealtime = true;
    # RestrictSUIDSGID = true;
    # SystemCallFilter = "@system-service";
    # SystemCallArchitectures = "native";
  };
}
