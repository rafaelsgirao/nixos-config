_: {
  services.sshguard = {
    enable = true;
    whitelist = [
      "192.168.10.0/24"
      "100.64.0.0/10"
    ];
    blacklist_file = "/var/lib/sshguard/blacklist.db";
  };

  environment.persistence."/pst".directories = [ "/var/lib/sshguard" ];
}
