{ config, lib, pkgs, sshKeys, ... }: {
  #Unlock encrypted zfs via ssh on boot
  #https://nixos.wiki/wiki/ZFS#Unlock_encrypted_zfs_via_ssh_on_boot
  #Inspiration:
  # https://github.com/ElvishJerricco/stage1-tpm-tailscale/blob/main/boot.nix
  networking.useDHCP = false;

  # This works, even when using systemd-networkd!
  networking.interfaces."eth0".wakeOnLan = {
    # Arch Wiki: "Note: Setting one of u, m or b along with g might also be necessary to enable the feature."
    #  ^^ https://wiki.archlinux.org/title/Wake-on-LAN
    enable = true;
  };

  boot = {

    # README: set this parameter on machines you import this file!
    initrd.kernelModules = [ "r8169" "e1000e" "uas" "atkbd" "usbhid" ];
    initrd.supportedFilesystems = [ "zfs" ];
    initrd.includeDefaultModules = lib.mkForce true;
    initrd.systemd.emergencyAccess = config.users.users.root.hashedPassword;
    initrd.network.ssh = {
      enable = true;
      port = 2222;
      hostKeys = [ /pst/etc/ssh-initrd/ssh_host_ed25519_key ];
      authorizedKeys = sshKeys;
    };

    initrd.systemd.network = config.systemd.network;
  };
  boot.initrd.systemd.storePaths = [ pkgs.toybox ];
  boot.initrd.systemd.extraBin = {
    toybox = "${pkgs.toybox}/bin/toybox";
  };

  boot.initrd.systemd.contents."/etc/profile".text = ''
    systemctl restart systemd-ask-password-console.service
  '';
}
