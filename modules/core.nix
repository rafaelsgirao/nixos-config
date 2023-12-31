{ config, pkgs, lib, sshKeys, inputs, hostSecretsDir, ... }:
let
  isVirt = config.rg.machineType == "virt";
  # inherit (lib) filterAttrs mapAttrs mapAttrs' nameValuePair;
in
{
  imports = [
    ./nebula.nix
    ./nix.nix
    ./ssh.nix
    ./hardware/networking.nix
    ./wakapi-client.nix
  ];


  rg = {
    enable = true;
    domain = "rafael.ovh";
  };
  zramSwap.memoryPercent = 25;

  # Nixinate options
  deploy = {
    enable = true;
    host = config.rg.ip;
    archiveFlake = config.rg.class != "workstation";
    sshUser = "rg";
    buildOn = "remote";
    #  Build the config with the nixos-rebuild command from your flakes nixpkgs,
    # instead of the hosts nixpkgs.
    # This makes cross-platform deployment fail, as it'll ignore the target's build platform
    # And always build derivations with the local system's architecture/nixpkgs.
    hermetic = false;
    substituteOnTarget = true;
  };


  boot = {
    kernelParams = [ "quiet" ];
    initrd.preDeviceCommands = ''
      echo " "
      echo " "
      echo "                                       Rafael Girão"
      echo "                                       E-mail: ${config.networking.hostName}@${config.rg.domain}"
      echo "                                       E-mail (alternative): rafael.s.girao@tecnico.ulisboa.pt"
      echo ""
      echo ""
    '';
  };


  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "kernel.yama.ptrace_scope" = 1;

    # https://adamierymenko.com/privileged-ports/
    # https://ar.al/2022/08/30/dear-linux-privileged-ports-must-die/
    # https://www.linuxquestions.org/linux/articles/Technical/Why_can_only_root_listen_to_ports_below_1024
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };


  zramSwap.enable = lib.mkDefault true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults lecture="never"
  '';

  networking = {
    inherit (config.rg) domain;
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5080 # port for whatever I feel like.
      ];
      allowedUDPPorts = [
        5080 # port for whatever I feel like.
      ];
    };
  };

  networking.firewall.logRefusedConnections =
    false; # This is really spammy w/ pub. IPs. makes desg unreadable

  # Select internationalisation properties.
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings.LC_TIME = "pt_PT.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pt-latin1";
  };

  environment.pathsToLink = [ "/libexec" ];

  users.mutableUsers = false;

  users.users.rg = {
    uid = 1000;
    description = "Rafael Girão";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "render"
      "scanner"
      "lp"
      "adbusers"
      "networkmanager"
      "qemu-libvirtd"
    ];
    isNormalUser = true;
    hashedPassword =
      "$6$zlh2QjXj/r3oHlO$oxqRDXvfm2EKyZN5wwjCzvTroZKzwwR3G/sJKOfun1UssUANPpg8AVSx6ILQSEDoIolMGbRkS76GdlP3g0Unf/";
    openssh.authorizedKeys.keys = sshKeys;
  };
  users.users.root.hashedPassword = config.users.users.rg.hashedPassword;


  hardware.nvidia.nvidiaSettings = lib.mkDefault false;

  services.earlyoom = {
    enable = lib.mkDefault true;
    extraArgs = [ "--avoid '(^|/)(code|chromium|ferdium|thunderbird)$'" ];
  };


  # 'to enable vendor fish completions provided by Nixpkgs you will also want to enable the fish shell in /etc/nixos/configuration.nix:'
  programs.fish.enable = true;

  programs.mtr.enable = true;


  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/3-optional-configuration.html
  #Aliases to receive root mail
  environment.etc."aliases".text = ''
    root: rafaelgirao+machine-alerts@proton.me
    rg: rafaelgirao+machine-alerts@proton.me
  '';

  age.secrets.sendmail-pass = {
    file = "${hostSecretsDir}/../sendmail-pass.age";
    mode = "444";
  };

  programs.msmtp = {
    enable = lib.mkDefault true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "plain";
      tls_starttls = "off";
    };
    accounts.default = {
      host = "mail.rafael.ovh";
      # set secure permissions for password file
      passwordeval = "${pkgs.coreutils}/bin/cat ${config.age.secrets.sendmail-pass.path}";
      user = "machines@rafael.ovh";
      from = "machines@rafael.ovh";
    };
  };

  documentation.dev.enable = true;

  boot.blacklistedKernelModules = [ "mei_me" ];

  environment.systemPackages = with pkgs; [
    #Basic utils
    tcpdump
    viu
    just
    cloc
    rsync
    nebula
    qrencode
    jq
    duf
    lf
    dogdns # Better dig alternative
    wget
    curl
    tmux
    file
    unzip
    zip
    whois
    ncdu
    killall
    ripgrep
    btop
    #Nice utils
    eza # managed by HM, but I might want to use this as root
    bat
    fd
    pre-commit
    python3
    openssh
    neofetch
    bashmount
    sshfs
    rclone
    unstable.yt-dlp
    speedtest-cli
    # sentry-cli
    rm-improved
    delta
    dua
    moreutils # Provides sponge which is nice for in-line replacing file contents
    mailutils

    inputs.agenix.packages.x86_64-linux.default
    traceroute
    iperf3
    nmap
    ruff
    black
    nload
  ]
  ++ lib.optionals (!isVirt)
    [
      usbutils #Provides lsusb
      nvme-cli
      dmidecode
      ethtool

      pciutils #Provides `lspci` command

    ];
}
