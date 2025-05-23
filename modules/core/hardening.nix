# Copied and adapted from:
# https://github.com/NixOS/nixpkgs/blob/68e06b5c7298cad3993b27cf60c67c80edbb3c2d/nixos/modules/profiles/hardened.nix#L1

# A profile with most (vanilla) hardening options enabled by default,
# potentially at the cost of stability, features and performance.
#
# This profile enables options that are known to affect system
# stability. If you experience any stability issues when using the
# profile, try disabling it. If you report an issue and use this
# profile, always mention that you do.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  # meta = {
  #   maintainers = [ maintainers.joachifm maintainers.emily ];
  # };

  boot.kernelPackages = mkIf (!config.rg.isBuilder) (mkForce pkgs.linuxPackages_hardened);

  nix.settings.allowed-users = [ "@users" ];

  #scudo breaks thunderbird & firefox (maybe everything Gecko?)
  #Consider opening upstream issue
  # environment.memoryAllocator.provider = mkDefault "scudo";
  # environment.memoryAllocator.provider = mkDefault "graphene-hardened";
  environment.variables.SCUDO_OPTIONS = mkDefault "ZeroContents=1";

  # Preferring convenience over security.
  # security.lockKernelModules = mkDefault true;

  security.protectKernelImage = mkDefault true;

  # security.allowSimultaneousMultithreading = mkDefault false;

  security.forcePageTableIsolation = mkDefault true;

  # This is required by podman to run containers in rootless mode - disabling anyway.
  #Enabling because everything remotely Electron-based or Flatpakked requires this (because bwrap)
  security.unprivilegedUsernsClone = true;

  # security.virtualisation.flushL1DataCache = mkDefault "always";

  # security.apparmor.enable = mkDefault true;
  # security.apparmor.killUnconfinedConfinables = mkDefault true;

  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"

    # Disable debugfs
    "debugfs=off"

    # Disable virtual syscalls:
    # https://tails.net/contribute/design/kernel_hardening/
    "vsyscall=none"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  # Hide kptrs even for processes with CAP_SYSLOG
  boot.kernel.sysctl."kernel.kptr_restrict" = mkOverride 500 2;

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_harden" = mkDefault 2;

  # Disable ftrace debugging
  boot.kernel.sysctl."kernel.ftrace_enabled" = mkDefault false;

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  # boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = mkDefault "1";
  # boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = mkDefault true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = mkDefault "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = mkDefault false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = mkDefault false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = mkDefault false;

  #nscd hardening
  systemd.services.nscd.serviceConfig = {
    SystemCallFilter = [ "@system-service" ];
    ProtectKernelModules = true;
    ProtectClock = true;
    PrivateDevices = true;
    ProtectKernelLogs = true;
    MemoryDenyWriteExecute = true;
    ProtectControlGroups = true;
    ProtectKernelTunables = true;
    ProtectHostname = true;
    # ProtectHome = "tmpfs";
    LockPersonality = true;
    ProtectProc = true;
    # PrivateUsers = true; #nscd serves /etc/passwd?
    # PrivateNetwork = true; #nscd serves DNS queries
    CapabilityBoundingSet = [ "" ];
    RestrictNamespaces = true;
    RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6 AF_NETLINK" ];
  };
}
