{ lib, config, ... }:
let
  isWorkstation = config.rg.class == "workstation";
in
{

  networking.networkmanager = lib.mkIf isWorkstation {
    enable = true;
    unmanaged = [ "nebula0" ];
    # dhcpcd doesn't start properly with malloc
    # see https://github.com/NixOS/nixpkgs/issues/151696
    dhcp = "internal";
    dns = "systemd-resolved"; #this is done upstream.
    connectionConfig = {
      mdns = 2;
    };
    settings = {
      "global-dns-domain-*".servers = "192.168.10.9 1.1.1.1";
    };
  };

  networking.nameservers = lib.mkIf isWorkstation [ "192.168.10.9" ];

  #resolved is bad software. it just doesn't work reliably.
  # Only keeping it in workstations for now, for mDNS/service-discovery.
  services.resolved = lib.mkIf isWorkstation {
    enable = true;
    #LLMNR is a Microsoft standard.
    #Microsoft is giving up on LLMNR in favour of mDNS.
    llmnr = "false";
    dnssec = "allow-downgrade";
    domains = [ config.rg.domain ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "9.9.9.9#dns.quad9.net" "2620:fe::9#dns.quad9.net" ];
    extraConfig = ''
      DNSOverTLS=opportunistic
    '';
  };
  services.avahi.enable = false;

  networking.dhcpcd.enable = false;

  #Arch wiki recommends opening these ports for mDNS and LLMNR
  networking.firewall.allowedUDPPorts = [ 5353 5355 ];
  networking.firewall.allowedTCPPorts = [ 5353 5355 ];
}

# https://github.com/krathalan/systemd-sandboxing/blob/master/NetworkManager.service.d/hardening.conf
#COMMENTED BECAUSE I NEED VPN BUT VPN NOT WORKING W THIS
# systemd.services."NetworkManager".serviceConfig = {
#   # File system
#   RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6 AF_NETLINK AF_PACKET" ];
#   ProtectHome = true;
#   ProtectSystem = "strict";
#   ProtectProc = "invisible";
#   ReadWritePaths = [ "/etc -/proc/sys/net -/var/lib/NetworkManager" ];
#   PrivateTmp = true;

#   PrivateDevices = true;

#   ProtectKernelTunables = true;
#   # ProtectKernelModules = true;
#   ProtectKernelLogs = true;

#   CapabilityBoundingSet = [ "-CAP_SYS_ADMIN CAP_SETUID CAP_SETGID CAP_SYS_CHROOT" ];
#   NoNewPrivileges = true;
#   ProtectHostname = true;
#   # ProtectClock = true; # needed for OpenVPN Connections
#   ProtectControlGroups = true;
#   RestrictNamespaces = true;
#   LockPersonality = true;
#   MemoryDenyWriteExecute = true;
#   RestrictRealtime = true;
#   RestrictSUIDSGID = true;
#   # DeviceAllow=/dev/net/tun
#   # DeviceAllow=/dev/net/tap
#   DeviceAllow = [ "/dev/net/tun" "/dev/net/tap" ];

#   SystemCallFilter = "@system-service @privileged";
#   SystemCallArchitectures = "native";

# };

# services.resolved = {
#   enable = true;
#   extraConfig = ''
#   [Network]
#   DNS=127.0.0.1
# '';
# };
# networking.resolvconf.enable = false;
