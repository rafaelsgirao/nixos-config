{
  lib,
  keys,
  ...
}:

{

  #SSH Server.
  services.openssh = {
    enable = true;
    openFirewall = false;
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

      PermitRootLogin = lib.mkDefault "no";
    };
    hostKeys = [
      {
        path = "/pst/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 100;
      }
    ];
  };

  #SSH Client.
  programs.ssh.knownHosts =
    (keys.toKnownHosts keys.systems) // (keys.toKnownHosts keys.categories.knownHosts);
}
