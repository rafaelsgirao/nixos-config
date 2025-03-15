{ config, lib, ... }:
{

  # Being headless, we don't need a GRUB splash image.
  boot.loader.grub.splashImage = null;

  # Don't start a tty on the serial consoles.
  # systemd.services."serial-getty@ttyS0".enable = lib.mkDefault false;
  # systemd.services."serial-getty@hvc0".enable = false;
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@".enable = false;

  #Causes too many things to get recompiled, beware
  # Warning: do NOT use this. spy's openGL drivers will fail to build if true.
  # When this isn't enabled, there's not even a need to build it locally.
  # environment.noXlibs = true;

  #fwupd needs udisks2. udisks2 needs polkit...
  # security.polkit.enable = false;
  # services.udisks2.enable = false;

  networking.networkmanager.enable = false;
  networking.dhcpcd.enable = !config.systemd.network.enable;
  networking.useDHCP = !config.systemd.network.enable;

  programs.command-not-found.enable = lib.mkDefault false;

  # Since we can't manually respond to a panic, just reboot.
  boot.kernelParams = [
    "panic=120"
    #  boot.panic_on_fail"
  ];

  services.logind.lidSwitch = "ignore";

  # services.resolved.enable = false;
  # networking.nameservers = [
  #   "127.0.0.1"
  #   "1.1.1.1"
  # ];

  #Separate user to run docker containers and other things on
  # users.users.apps = {
  #   uid = 1010;
  #   isNormalUser = true;

  #   # extraGroups = [ "docker" ];
  #   # group = "apps";
  # };
  # users.groups.apps = { };

  # environment.memoryAllocator.provider = "graphene-hardened";
  # boot.kernelPackages = lib.mkForce pkgs.linuxPackages_hardened;

  # boot.initrd.includeDefaultModules = false;

  # No need for fonts on a server
  fonts.fontconfig.enable = lib.mkDefault false;

  # Notice this also disables --help for some commands such es nixos-rebuild
  documentation.enable = lib.mkDefault false;
  documentation.info.enable = lib.mkDefault false;
  documentation.man.enable = lib.mkDefault false;
  documentation.nixos.enable = lib.mkDefault false;

  # Print the URL instead on servers
  environment.variables.BROWSER = "echo";
  # programs.command-not-found.enable = mkDefault false;

  #  https://github.com/CISOfy/lynis/issues/120
  services.openssh.extraConfig = ''
    Compression no
    TCPKeepAlive no
    MaxAuthTries 3
    AllowAgentForwarding no
  '';

  environment.defaultPackages = [ ];
  xdg.icons.enable = false;
  xdg.mime.enable = false;
  xdg.autostart.enable = false;
  xdg.sounds.enable = false;

  systemd = {
    # Given that our systems are headless, emergency mode is useless.
    # We prefer the system to attempt to continue booting so
    # that we can hopefully still access it remotely.
    enableEmergencyMode = false;

    # For more detail, see:
    #   https://0pointer.de/blog/projects/watchdog.html
    watchdog = {
      # systemd will send a signal to the hardware watchdog at half
      # the interval defined here, so every 10s.
      # If the hardware watchdog does not get a signal for 20s,
      # it will forcefully reboot the system.
      runtimeTime = "20s";
      # Forcefully reboot if the final stage of the reboot
      # hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      rebootTime = "30s";
    };
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  # use TCP BBR has significantly increased throughput and reduced latency for connections
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # Ensure a clean & sparkling /tmp on fresh boots.
  boot.tmp.cleanOnBoot = lib.mkDefault true;

}
