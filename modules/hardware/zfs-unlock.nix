{ lib, sshKeys, ... }: {
  #Unlock encrypted zfs via ssh on boot
  #https://nixos.wiki/wiki/ZFS#Unlock_encrypted_zfs_via_ssh_on_boot
  networking.useDHCP = false;
  boot = {
    #Wipe root dataset to a clean slate on each reboot
    # initrd.postDeviceCommands = lib.mkAfter ''
    #   zfs rollback -r spypool/local/root@blank
    # '';

    # README: set this parameter on machines you import this file!
    # kernelParams = [ "ip=192.168.1.80::192.168.1.1:255.255.255.0::eth0:none" ];
    initrd.kernelModules = [ "r8169" "e1000e" "uas" "atkbd" "usbhid" ];
    initrd.supportedFilesystems = [ "zfs" ];
    initrd.includeDefaultModules = lib.mkForce true;
    initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [ /pst/etc/ssh-initrd/ssh_host_ed25519_key ];
        #TODO: come from agenix?
        authorizedKeys = sshKeys;
      };
      # this will automatically load the zfs password prompt on login
      # and kill the other prompt so boot can continue
      # postCommands = lib.mkDefault ''
      #   cat << EOF > /root/.profile
      #   if pgrep -x "zfs" > /dev/null
      #   then
      #     zfs load-key -a
      #     killall zfs
      #   else
      #     echo "zfs not running -- maybe the pool is taking some time to load for some unforseen reason."
      #   fi
      #   EOF
      # '';
    };
  };
}
