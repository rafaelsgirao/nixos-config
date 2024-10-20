{ lib, ... }:

{
  imports = [ ./bluetooth.nix ];
  # ++ lib.optionals (isWorkstation) [ ./cups.nix ];

  #systemd.services."touchegg".serviceConfig = {
  #  MemoryDenyWriteExecute = true;
  #  # RestrictAddressFamilies = [ "AF_UNIX" ]; # There's probably a way to do this
  #  # IPAddressAllow = "127.0.0.1/32"
  #  # PrivateNetwork = true; # THIS BREAKS!
  #  CapabilityBoundingSet = [ "-CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_SYS_CHROOT" ];
  #  ProtectHome = true;
  #  RestrictRealtime = true;
  #  ProtectHostname = true;
  #  IPAddressDeny = "any";
  #  ProtectSystem = "full";
  #  RestrictNamespaces = true;
  #  ProtectProc = "invisible";
  #  ProtectControlGroups = true;
  #  RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6 AF_NETLINK" ];
  #  ProtectKernelLogs = true;
  #  PrivateTmp = true;
  #  ProtectKernelTunables = true;
  #  ProtectKernelModules = true;
  #  # ProtectClock = true; # THIS BREAKS!
  #  NoNewPrivileges = true;
  #  RestrictSUIDSGID = true;
  #  LockPersonality = true;
  #  # SystemCallFilter = [ "@system-service" "~@resources @privileged" ];

  #  # SystemCallArchitecture = "native";
  #  # ProcSubset = "pid";
  #};
  ##User-side "client"
  #systemd.user.services.touchegg-client = {
  #  description = "Touchegg client";
  #  wantedBy = [ "graphical-session.target" ];
  #  partOf = [ "graphical-session.target" ];
  #  path = [ pkgs.playerctl pkgs.pamixer ];
  #  serviceConfig = {
  #    Restart = "always";
  #    RestartSec = "1800s";
  #  };
  #  serviceConfig.ExecStart = "${pkgs.touchegg}/bin/touchegg --client";

  #};

  # don’t shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  #Battery life thingy
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      #Only BAT1 exists on thinkpad(?)
      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1 = 80;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
  services.power-profiles-daemon.enable = lib.mkForce false;

  #Enable upower
  services.upower.enable = true;

  # Allow DHCP & DNS so occasional Wi-Fi hotspots work.
  networking.firewall.allowedTCPPorts = [
    53
    67
  ];
  networking.firewall.allowedUDPPorts = [
    53
    67
  ];

  #Enable Scanning
  # hardware.sane.enable = true;
  # hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  #  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin pkgs.sane-airscan ];

}
