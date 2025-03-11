let
  # Unsupported by agenix:
  #rg-yubikey-1-rk = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEwOBxayZyd/zGYyoTRN2rdIQM71nzVT3lISg2pNfrZRAAAABHNzaDo=";

  users = [
    "age1yubikey1qfwmheguzsuma4n9dq2vknkkh28d4vcnmvrv82gtzd6gf2scnel45wnnz44" # Yubikey age recipient
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7foe85vNDLm0vyVVugR8ThC1VjHuAtqAQ/K2AAVE9r rg@sazed[dec '24]"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID97/zlRwgxhnOyqHcawWjlL9XjbdmrWbYwayj1bG67I rg@vin[jan '25]"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb+ipW3JOFhud1apnnMH4Ycm95Br/Fz8/0b1SqaNO6s rg@adolin"

    # Age only supports RSA keys and ed25519 :(
    #    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJi2uB1uGKJSSVYq0zM1i26l5Lr+dWw1M+I73v9kdhNzdE995c8a4uIl0J5eU+3XV4LJP/AFLv1eRBaVInTVGQ8= rg@sazed-TPM"
    #    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBxyt2Uhru+PIf9SKRF96AW05P9WuyR7NKbS6OZyElNjOT+1qmkeL82+7B5qeHsACA3ZRo4svorIS1Q8khLmexk= rg@vin-TPM"
  ];

  dtcKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYiuCHjX9Dmq69WoAn7EfgovnFLv0VhjL7BSTYQcFa7 dtc@apollo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlaWu32ANU+sWFcwKrPlqD/oW3lC3/hrA1Z3+ubuh5A dtc@bacchus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmAw3MrBc3MERcNBkerJwfh9fmfD1OCeYnLVJVxs2Rs dtc@xiaomi11tpro"
  ];

  spy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD";
  saxton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIgLXN8cCbZ19eQtmtRsn1R1JEF0gg9lLYWajB2VeE6";
  sazed = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL98QtOSOE5mmB/EXHsINd5mHc46gkynP2FBN939BlEc root@sazed";
  vin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRXa7/kHjUK8do4degCAvq1Ak2k3BGIn1kLYtjbQsjk root@vin";
  adolin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBECHNAitjjdOJA3IGsl8OEH+HQVlJh04ISHCizA5p+Z root@adolin";

  workstations = [
    sazed
    vin
    adolin
  ];

  servers = [
    spy
    saxton
  ];

  systems = workstations ++ servers;
in
{
  #TODO: this so ugly!

  # Secrets for workstations.
  "RNLDEI-wireguard.age".publicKeys = workstations ++ users;
  "SSH-config.age".publicKeys = workstations ++ users;
  "attic-config.age".publicKeys = workstations ++ users;
  "wallpaper.age".publicKeys = workstations ++ users;

  # Secrets for servers.
  # empty.

  # secrets for all.
  "restic-env.age".publicKeys = systems ++ users;
  "restic-password.age".publicKeys = systems ++ users;
  "wakatime-config.age".publicKeys = systems ++ users;
  "ACME-env.age".publicKeys = systems ++ users;
  "sendmail-pass.age".publicKeys = systems ++ users;
  "rclone-config.age".publicKeys = systems ++ users;
  "ENV-mailrise.age".publicKeys = systems ++ users;

  # spy secrets.
  "spy/ENV-attic.age".publicKeys = [ spy ] ++ users;
  "spy/HC-alive.age".publicKeys = [ spy ] ++ users;
  "spy/HC-nextcloud.age".publicKeys = [ spy ] ++ users;
  "spy/HC-backups.age".publicKeys = [ spy ] ++ users;
  "spy/Nextcloud-adminpass.age".publicKeys = [ spy ] ++ users;
  "spy/ENV-mediafederation.age".publicKeys = [ spy ] ++ users ++ dtcKeys;
  # "spy/Nextcloud-redispass.age".publicKeys = [ spy ] ++ users;
  # "spy/Nextcloud-secretfile.age".publicKeys = [ spy ] ++ users;

  # saxton secrets.
  "saxton/ENV-ist-discord-bot.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-WCBot.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-bolsas-scraper.age".publicKeys = [ saxton ] ++ users;
  "saxton/HC-alive.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-sirptDNSBL.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-vaultwarden.age".publicKeys = [ saxton ] ++ users;
  "saxton/Mailserver-pwd-rafael.age".publicKeys = [ saxton ] ++ users;
  "saxton/Mailserver-pwd-machines.age".publicKeys = [ saxton ] ++ users;
  "saxton/Caddy-super-secret-config.age".publicKeys = [ saxton ] ++ users;

}
