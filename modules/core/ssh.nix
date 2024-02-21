{ lib, ... }:

{

  #SSH Server.
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
      # PasswordAuthentication = true;
      UseDns = false;
      # unbind gnupg sockets if they exists

      PermitRootLogin = "yes";
    };
    hostKeys = [
      {
        path = "/pst/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 100;
      }
    ];
  };

}
