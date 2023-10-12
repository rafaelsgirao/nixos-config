let
  rg-scout = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a";
  rg-medic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTJmVou9C3Q5hZ48FcCv3UoTrG5m2QAf26V8RxZfwxB";
  users = [ rg-scout rg-medic ];

  scout = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlOwjvhd+yIUCNLtK4q3nNT3sZNa/CfPcvuxXMU02Fq";

  medic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGItSBTrnu+uZYRbvy9HZO3zGS5Mrdozk8Imjit3/zZV";

  spy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD";

  engie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHPoJmEzz1fs+KPDQh0E+Py3yb9cTzEd3E4gVLai2/i";

  systems = [
    scout
    medic
    spy
    engie
  ];
in
{
  #so ugly!

  "wakatime-config.age".publicKeys = systems ++ users;
  "ACME-env.age".publicKeys = systems ++ users;
  "sendmail-pass.age".publicKeys = systems ++ users;
  "RGNet-CA.age".publicKeys = systems ++ users;
  "rclone-config.age".publicKeys = systems ++ users;
  "restic-env.age".publicKeys = [ engie spy ] ++ users;
  "restic-password.age".publicKeys = [ engie spy ] ++ users;
  "SSH-config.age".publicKeys = [ scout medic ] ++ users;

  #Scout secrets
  "scout/RGNet-key.age".publicKeys = [ scout ] ++ users;
  "scout/RGNet-cert.age".publicKeys = [ scout ] ++ users;

  #Medic secrets
  "medic/RGNet-key.age".publicKeys = [ medic ] ++ users;
  "medic/RGNet-cert.age".publicKeys = [ medic ] ++ users;
  "medic/HC-alive.age".publicKeys = [ medic ] ++ users;

  #Spy secrets
  "spy/RGNet-key.age".publicKeys = [ spy ] ++ users;
  "spy/RGNet-cert.age".publicKeys = [ spy ] ++ users;
  "spy/Transmission-creds.age".publicKeys = [ spy ] ++ users;
  "spy/HC-alive.age".publicKeys = [ spy ] ++ users;
  "spy/HC-nextcloud.age".publicKeys = [ spy ] ++ users;
  "spy/HC-backups.age".publicKeys = [ spy ] ++ users;
  "spy/Restic-password.age".publicKeys = [ spy ] ++ users;
  "spy/Nextcloud-adminpass.age".publicKeys = [ spy ] ++ users;
  # "spy/Nextcloud-redispass.age".publicKeys = [ spy ] ++ users;
  # "spy/Nextcloud-secretfile.age".publicKeys = [ spy ] ++ users;

  #Engie secrets
  "engie/ENV-WCBot.age".publicKeys = [ engie ] ++ users;
  "engie/RGNet-key.age".publicKeys = [ engie ] ++ users;
  "engie/RGNet-cert.age".publicKeys = [ engie ] ++ users;
  "engie/ENV-bolsas-scraper.age".publicKeys = [ engie ] ++ users;
  "engie/HC-alive.age".publicKeys = [ engie ] ++ users;
  "engie/HC-bolsas.age".publicKeys = [ engie ] ++ users;
  # "engie/HC-sirpt.age".publicKeys = [ engie ] ++ users;
  "engie/ENV-sirptDNSBL.age".publicKeys = [ engie ] ++ users;
  "engie/ENV-vaultwarden.age".publicKeys = [ engie ] ++ users;
  "engie/Mailserver-pwd-rafael.age".publicKeys = [ engie ] ++ users;
  "engie/Mailserver-pwd-machines.age".publicKeys = [ engie ] ++ users;

}
