{ lib, config, ... }:
let
  isWorkstation = config.rg.class == "workstation";
in
{

  networking.networkmanager = lib.mkIf isWorkstation {
    enable = true;
    unmanaged = [ "nebula0" ];
    dns = "systemd-resolved"; #this is done upstream.
    connectionConfig = {
      mdns = 2;
    };
    extraConfig = ''
      [global-dns-domain-*]
      servers=${config.rg.ip},192.168.10.3
    '';
  };

  networking.nameservers = [ "192.168.10.5" "192.168.10.3" ];

  #resolved allows us to have less processes running:
  services.resolved = {
    enable = true;
    #LLMNR is a Microsoft standard.
    #Microsoft is giving up on LLMNR in favour of mDNS.
    llmnr = "false";
    dnssec = "allow-downgrade";
    domains = [ config.rg.domain ];
    fallbackDns = [ "192.168.10.3" "1.1.1.1#one.one.one.one" "9.9.9.9#dns.quad9.net" "2620:fe::9#dns.quad9.net" ];
    extraConfig = ''
      DNSOverTLS=opportunistic
    '';
  };
  services.avahi.enable = false;

  # # Use networkd instead of the pile of shell scripts
  #TODO: engie's config is incompatible with networkd ATM.
  networking = {
    useNetworkd = lib.mkDefault true;
    useDHCP = lib.mkDefault false;

  };
  systemd.network.enable = config.rg.class == "server";

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

# networking.dhcpcd.enable = false;
# services.resolved = {
#   enable = true;
#   extraConfig = ''
#   [Network]
#   DNS=127.0.0.1
# '';
# };
# networking.resolvconf.enable = false;
