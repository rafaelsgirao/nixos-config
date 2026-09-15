{
  config,
  lib,
  pkgs,
  keys,
  ...
}:
let
  cfg = config.rg.zfsUnlockInitrd;
in
{
  options.rg.zfsUnlockInitrd.wolInterfaces = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "eth0" ];
    description = "Wired interfaces to arm for wake-on-LAN. Empty on hosts with no NIC to arm.";
  };

  #Unlock encrypted zfs via ssh on boot
  #https://nixos.wiki/wiki/ZFS#Unlock_encrypted_zfs_via_ssh_on_boot
  #Inspiration:
  # https://github.com/ElvishJerricco/stage1-tpm-tailscale/blob/main/boot.nix
  config = {
    networking.useDHCP = false;

    # This works, even when using systemd-networkd!
    networking.interfaces = lib.genAttrs cfg.wolInterfaces (_: {
      wakeOnLan = {
        # Arch Wiki: "Note: Setting one of u, m or b along with g might also be necessary to enable the feature."
        #  ^^ https://wiki.archlinux.org/title/Wake-on-LAN
        enable = true;
      };
    });

    boot = {

      # README: set this parameter on machines you import this file!
      initrd.kernelModules = [
        "r8169"
        "r8152"
        "e1000e"
        "uas"
        "atkbd"
        "usbhid"
      ];
      initrd.supportedFilesystems = [ "zfs" ];
      initrd.includeDefaultModules = lib.mkForce true;
      initrd.systemd.emergencyAccess = lib.mkDefault config.users.users.root.hashedPassword;
      initrd.network.ssh = {
        enable = true;
        port = lib.mkDefault 2222;
        hostKeys = [ /pst/etc/ssh-initrd/ssh_host_ed25519_key ];
        authorizedKeys = keys.users.rg;
      };

      # Mirrors stage 2 only where networkd is what runs there. mkIf rather
      # than mkDefault: nixpkgs already defines initrd's network.enable at
      # mkDefault, so a second default-priority definition ties and conflicts.
      # Hosts on NetworkManager have nothing to mirror and declare the stage-1
      # networks themselves.
      initrd.systemd.network = lib.mkIf config.systemd.network.enable config.systemd.network;
    };
    boot.initrd.systemd.storePaths = [ pkgs.toybox ];
    boot.initrd.systemd.extraBin = {
      toybox = "${pkgs.toybox}/bin/toybox";
    };

    boot.initrd.systemd.contents."/etc/profile".text = ''
      systemctl restart systemd-ask-password-console.service
    '';
  };
}
