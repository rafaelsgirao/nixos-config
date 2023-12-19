let
  rg-scout = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDT738i9yW4X/sO5IKD10zE/A4+Kz9ep01TkMLTrd1a";
  users = [ rg-scout ];

  scout = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlOwjvhd+yIUCNLtK4q3nNT3sZNa/CfPcvuxXMU02Fq";

  spy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD";

  saxton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIgLXN8cCbZ19eQtmtRsn1R1JEF0gg9lLYWajB2VeE6";

  systems = [
    scout
    spy
    saxton
  ];
in
{
  #so ugly!

  "wakatime-config.age".publicKeys = systems ++ users;
  "ACME-env.age".publicKeys = systems ++ users;
  "sendmail-pass.age".publicKeys = systems ++ users;
  "RGNet-CA.age".publicKeys = systems ++ users;
  "rclone-config.age".publicKeys = systems ++ users;
  "restic-env.age".publicKeys = [ saxton spy ] ++ users;
  "restic-password.age".publicKeys = [ saxton spy ] ++ users;
  "SSH-config.age".publicKeys = [ scout ] ++ users;
  "BinaryCache-pub.age".publicKeys = systems ++ users;

  #Scout secrets
  "scout/RGNet-key.age".publicKeys = [ scout ] ++ users;
  "scout/RGNet-cert.age".publicKeys = [ scout ] ++ users;

  # Medic secrets
  "medic/RGNet-key.age".publicKeys = users;
  "medic/RGNet-cert.age".publicKeys = users;
  "medic/HC-alive.age".publicKeys = users;

  #Spy secrets
  "spy/BinaryCache-key.age".publicKeys = [ spy ] ++ users;
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

  #saxton secrets
  "saxton/ENV-WCBot.age".publicKeys = [ saxton ] ++ users;
  "saxton/RGNet-key.age".publicKeys = [ saxton ] ++ users;
  "saxton/RGNet-cert.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-bolsas-scraper.age".publicKeys = [ saxton ] ++ users;
  "saxton/HC-alive.age".publicKeys = [ saxton ] ++ users;
  "saxton/HC-bolsas.age".publicKeys = [ saxton ] ++ users;
  # "saxton/HC-sirpt.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-sirptDNSBL.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-vaultwarden.age".publicKeys = [ saxton ] ++ users;
  "saxton/Mailserver-pwd-rafael.age".publicKeys = [ saxton ] ++ users;
  "saxton/Mailserver-pwd-machines.age".publicKeys = [ saxton ] ++ users;

}
