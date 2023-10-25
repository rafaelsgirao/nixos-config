{ config, pkgs, lib, sshKeys, inputs, hostSecretsDir, ... }: {
  imports = [
    ./nebula.nix
    ./networking.nix
    ./wakapi-client.nix
  ];

  #--------------------------------------------
  #-------------Boot Settings------------------
  #--------------------------------------------


  rg = {
    enable = true;
    domain = "rafael.ovh";
  };
  zramSwap.memoryPercent = 25;

  # Nixinate options
  deploy = {
    enable = true;
    host = config.rg.ip;
    sshUser = "rg";
    buildOn = "local";
    #  Build the config with the nixos-rebuild command from your flakes nixpkgs,
    # instead of the hosts nixpkgs.
    hermetic = true;
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #Enable use of Flakes.
  nix.package = pkgs.nixFlakes;
  nix.settings = {
    # Enable flakes
    experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
    ];

    allowed-users = [ "@wheel" ];
    trusted-users = [ "rg" "root" ];

    # Fallback quickly if substituters are not available.
    connect-timeout = 5;

    # The default at 10 is rarely enough.
    log-lines = lib.mkDefault 30;

    # Avoid disk full issues
    max-free = lib.mkDefault (3000 * 1024 * 1024);
    min-free = lib.mkDefault (512 * 1024 * 1024);

    # Avoid copying unnecessary stuff over SSH
    builders-use-substitutes = true;
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "kernel.yama.ptrace_scope" = 1;

    # https://adamierymenko.com/privileged-ports/
    # https://ar.al/2022/08/30/dear-linux-privileged-ports-must-die/
    # https://www.linuxquestions.org/linux/articles/Technical/Why_can_only_root_listen_to_ports_below_1024
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  zramSwap.enable = lib.mkDefault true;
  #--------------------------------------------
  #-------------Basic Settings-----------------
  #--------------------------------------------

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.flake-utils.flake = inputs.flake-utils;
  nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  nix.registry.unstable.flake = inputs.nixpkgs-unstable;

  nix.nixPath = [
    "nixpkgs=/etc/channels/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";
  security.sudo.execWheelOnly = true;

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
  #Needed for Colmena, for now.
  users.users.root.openssh.authorizedKeys.keys = sshKeys;
  users.users.root.hashedPassword = config.users.users.rg.hashedPassword;
  # users.users.root.openssh.authorizedKeys.keys = [
  #   "no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-x11-forwarding sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPPsEKHGmtdhA+uqziPEGnJirEXfFQdqCDyIFJ2z1MKgAAAABHNzaDo= Yubikey-U2F"
  # ];


  #--------------------------------------------
  #-------------OpenSSH Settings---------------
  #--------------------------------------------
  services.openssh = {
    enable = true;
    #Users shouldn't be able to add SSH keys outside this configuration
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    settings = {
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      UseDns = false;
      # unbind gnupg sockets if they exists

      PermitRootLogin = "no";
    };
    hostKeys = [
      {
        path = "/pst/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 100;
      }
    ];
  };
  hardware.nvidia.nvidiaSettings = lib.mkForce false;

  services.earlyoom = {
    enable = lib.mkDefault true;
    extraArgs = [ "--avoid '(^|/)(code|chromium|ferdium|thunderbird)$'" ];
  };

  #Automatically saves up space in nix-store by hardlinking
  #files with identical content
  #This is apparently a costly operation in HDDs, so only enabled per-machine
  #  nix.settings.auto-optimise-store = false;

  # 'to enable vendor fish completions provided by Nixpkgs you will also want to enable the fish shell in /etc/nixos/configuration.nix:'
  programs.fish.enable = true;

  programs.mtr.enable = true;


  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/3-optional-configuration.html
  #Aliases to receive root mail
  environment.etc."aliases".text = ''
    root: machine-alerts@rafael.ovh
    rg: machine-alerts@rafael.ovh
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

  boot.blacklistedKernelModules = [ "mei_me" ];

  programs.ssh = {
    knownHosts = {
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "192.168.10.1".publicKey =
        "192.168.10.1 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlOwjvhd+yIUCNLtK4q3nNT3sZNa/CfPcvuxXMU02Fq";
      "192.168.10.3".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHPoJmEzz1fs+KPDQh0E+Py3yb9cTzEd3E4gVLai2/i";
      "192.168.10.5".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGItSBTrnu+uZYRbvy9HZO3zGS5Mrdozk8Imjit3/zZV";
      "192.168.10.6".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD";
      "192.168.10.8".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDg6mKvXX9il6i2k3eG3o6Nkf/63EfMf35SYNOH+wXii";
      "repo.dsi.tecnico.ulisboa.pt".publicKey =
        "repo.dsi.tecnico.ulisboa.pt ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAwJLvpcT0ZAZXzxFgvNPr8uwAg4EEAH2eSvPoeL+jX";
    };
  };
  #Security implications if true
  #... but with nix.settings.sandbox requires it....
  # security.allowUserNamespaces = lib.mkForce false;

  nix.distributedBuilds = !config.rg.isBuilder;

  programs.ssh.extraConfig = lib.mkIf (!config.rg.isBuilder) ''
    # Host medicbuilder
    #   HostName 192.168.10.5
    #   Port 22
    #   User root
    #   # IdentitiesOnly yes
    #   # IdentityFile /root/.ssh/id_builder
    Host spybuilder
      HostName 192.168.10.6
      Port 22
      User root
      # IdentitiesOnly yes
      # IdentityFile /root/.ssh/id_builder
  '';

  nix.buildMachines = lib.mkIf (!config.rg.isBuilder) [{
    sshUser = "root";
    sshKey = "/home/rg/.ssh/id_ed25519";
    protocol = "ssh-ng";
    # publicHostKey = "bla";
    hostName = "192.168.10.6";
    systems = [ "x86_64-linux" "aarch64-linux" ];
    maxJobs = 4;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];

  # Stop using nscd, was eating my CPU for no reason
  services.nscd.enableNsncd = true;

  environment.systemPackages = with pkgs; [
    #Basic utils
    ethtool
    tcpdump
    viu
    just
    cloc
    dmidecode
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
    #Provides `lspci` command
    pciutils
    killall
    ripgrep
    btop
    #Nice utils
    exa # managed by HM, but I might want to use this as root
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
    nvme-cli
    ruff
    black
    nload
  ];
}
