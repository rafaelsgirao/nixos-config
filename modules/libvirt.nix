{ ... }: {
  #Enable libvirtd
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd = {
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      swtpm.enable = true; # Enables creation of software TPM
      runAsRoot = true;
    };
  };

  #-----
  #Libvirt jail
  #-----
  #To mount this on Windows 10, install SSHFS-Win
  #then mount with \\sshfs.k\libvirtsftp@192.168.122.1
  #(private key needs to be named id_rsa even if it's id_ed25519 because stupid)
  #Equivalent to 'user_allow_other' in /etc/fuse.conf
  programs.fuse.userAllowOther = true;

  users.groups.libvirtsftp = { };
  users.users.libvirtsftp = {
    group = "libvirtsftp";
    uid = 1050;
    shell = null;
    isSystemUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4o35oJ+x4Cvs9enb/EPUNlLMGUa9g9iqSngJbnumGB rg@WIN10-VM@Scout"
    ];
  };
  services.openssh.extraConfig = ''
    Match group libvirtsftp
      ChrootDirectory /libvirtjail/%u
      X11Forwarding no
      AllowTcpForwarding no
      PasswordAuthentication no
      ForceCommand internal-sftp
  '';
  #Additionally make SSHd listen on libvirt's host address
  # VMs can just connect to the host's own nebula IP address
  # services.openssh.listenAddresses = [
  #   {
  #     addr = "192.168.122.1";
  #     port = 22;
  #   }
  # ];
  users.users.rg.extraGroups = [ "libvirtd" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
