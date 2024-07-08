_: {
  services.sshguard = {
    enable = true;
    whitelist = [ "192.168.10.0/24" ];
    blacklist_file = "/pst/var/lib/sshguard/blacklist.db";

  };
}
