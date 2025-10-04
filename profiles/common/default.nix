{ profiles, pkgs, ... }:
{
  imports = with profiles.common; [
    nix
    options
  ];

  rg = {
    enable = true;
    domain = "rsg.ovh";
  };

  environment.systemPackages = with pkgs; [
    #Basic utils
    tcpdump
    viu
    cloc
    rsync
    qrencode
    jq
    duf
    lf
    dogdns # Better dig alternative
    wget
    curl
    tmux
    file
    fswatch
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
    python3
    openssh
    neofetch
    sshfs
    rclone
    speedtest-cli
    rm-improved
    delta
    dua
    mailutils
    pv

    iperf3
    nmap
    rustscan
    nload
    nix-output-monitor
    nix-tree
    nix-top
  ];

}
