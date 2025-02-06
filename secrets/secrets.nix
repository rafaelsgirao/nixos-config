let
  # Unsupported by agenix:
  #rg-yubikey-1-rk = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEwOBxayZyd/zGYyoTRN2rdIQM71nzVT3lISg2pNfrZRAAAABHNzaDo=";

  #FIXME: add more 'users' for redundancy!
  users = [
    "age1yubikey1qfwmheguzsuma4n9dq2vknkkh28d4vcnmvrv82gtzd6gf2scnel45wnnz44" # Yubikey age recipient
    # Age only supports RSA keys and ed25519 :(
    #    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJi2uB1uGKJSSVYq0zM1i26l5Lr+dWw1M+I73v9kdhNzdE995c8a4uIl0J5eU+3XV4LJP/AFLv1eRBaVInTVGQ8= rg@sazed-TPM"
    #    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBxyt2Uhru+PIf9SKRF96AW05P9WuyR7NKbS6OZyElNjOT+1qmkeL82+7B5qeHsACA3ZRo4svorIS1Q8khLmexk= rg@vin-TPM"
  ];

  dtcKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYiuCHjX9Dmq69WoAn7EfgovnFLv0VhjL7BSTYQcFa7 dtc@apollo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlaWu32ANU+sWFcwKrPlqD/oW3lC3/hrA1Z3+ubuh5A dtc@bacchus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmAw3MrBc3MERcNBkerJwfh9fmfD1OCeYnLVJVxs2Rs dtc@xiaomi11tpro"
  ];

  scout = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlOwjvhd+yIUCNLtK4q3nNT3sZNa/CfPcvuxXMU02Fq";
  spy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD";
  saxton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIgLXN8cCbZ19eQtmtRsn1R1JEF0gg9lLYWajB2VeE6";
  sazed = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL98QtOSOE5mmB/EXHsINd5mHc46gkynP2FBN939BlEc root@sazed";
  vin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRXa7/kHjUK8do4degCAvq1Ak2k3BGIn1kLYtjbQsjk root@vin";

  cluster-nodes = [
    #TODO: change when prod
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSnqxAKupYw0c0jIHBdLfPOCVxQHKF033Z3MRg7e9EY" # node-a
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9gdgB5xSKVwTG4fAw4nIBV+HxY4pGOxbE/ciNyzMZW" # node-b
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+0QmD4kVio9vs9K0dOun2og9iu/B2pH7yYzxG4Vo6O" # node-c
  ];
  workstations = [
    scout
    sazed
    vin
  ];

  servers = [
    spy
    saxton
  ] ++ cluster-nodes;

  systems = workstations ++ servers;
in
{
  #TODO: this so ugly!

  # Secrets to be accessed manually, not programatically by machines.
  "RGNet-key.age".publicKeys = users;
  "demo/RGNet-key.age".publicKeys = users;
  "demo/RGNet-cert.age".publicKeys = users;

  # Secrets for workstations.
  "RNLDEI-wireguard.age".publicKeys = workstations ++ users;
  "SSH-config.age".publicKeys = workstations ++ users;
  "attic-config.age".publicKeys = workstations ++ users;

  # Secrets for servers.

  # Secrets for cluster nodes.
  "cluster/ENV-garage.age".publicKeys = cluster-nodes ++ users;

  # secrets for all.
  "restic-env.age".publicKeys = systems ++ users;
  "restic-password.age".publicKeys = systems ++ users;
  "wakatime-config.age".publicKeys = systems ++ users;
  "ACME-env.age".publicKeys = systems ++ users;
  "sendmail-pass.age".publicKeys = systems ++ users;
  "RGNet-CA.age".publicKeys = systems ++ users;
  "rclone-config.age".publicKeys = systems ++ users;
  "ENV-mailrise.age".publicKeys = systems ++ users;

  # scout secrets.
  "scout/RGNet-key.age".publicKeys = [ scout ] ++ users;
  "scout/RGNet-cert.age".publicKeys = [ scout ] ++ users;
  "scout/unFTP-creds.age".publicKeys = [ scout ] ++ users;

  # spy secrets.
  "spy/ENV-attic.age".publicKeys = [ spy ] ++ users;
  "spy/RGNet-key.age".publicKeys = [ spy ] ++ users;
  "spy/RGNet-cert.age".publicKeys = [ spy ] ++ users;
  "spy/Transmission-creds.age".publicKeys = [ spy ] ++ users;
  "spy/HC-alive.age".publicKeys = [ spy ] ++ users;
  "spy/HC-nextcloud.age".publicKeys = [ spy ] ++ users;
  "spy/HC-backups.age".publicKeys = [ spy ] ++ users;
  "spy/Nextcloud-adminpass.age".publicKeys = [ spy ] ++ users;
  "spy/ENV-flood-ui.age".publicKeys = [ spy ] ++ users;
  "spy/ENV-frigate.age".publicKeys = [ spy ] ++ users;
  "spy/ENV-bitmagnet.age".publicKeys = [ spy ] ++ users;
  "spy/ENV-woodpecker.age".publicKeys = [ spy ] ++ users;
  "spy/ENV-mediafederation.age".publicKeys = [ spy ] ++ users ++ dtcKeys;
  # "spy/Nextcloud-redispass.age".publicKeys = [ spy ] ++ users;
  # "spy/Nextcloud-secretfile.age".publicKeys = [ spy ] ++ users;

  # saxton secrets.
  "saxton/ENV-ist-discord-bot.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-WCBot.age".publicKeys = [ saxton ] ++ users;
  "saxton/RGNet-key.age".publicKeys = [ saxton ] ++ users;
  "saxton/RGNet-cert.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-bolsas-scraper.age".publicKeys = [ saxton ] ++ users;
  "saxton/HC-alive.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-sirptDNSBL.age".publicKeys = [ saxton ] ++ users;
  "saxton/ENV-vaultwarden.age".publicKeys = [ saxton ] ++ users;
  "saxton/Mailserver-pwd-rafael.age".publicKeys = [ saxton ] ++ users;
  "saxton/Mailserver-pwd-machines.age".publicKeys = [ saxton ] ++ users;
  "saxton/Caddy-super-secret-config.age".publicKeys = [ saxton ] ++ users;

  # sazed secrets.
  "sazed/RGNet-key.age".publicKeys = [ sazed ] ++ users;
  "sazed/RGNet-cert.age".publicKeys = [ sazed ] ++ users;

  # vin secrets.
  "vin/RGNet-key.age".publicKeys = [ vin ] ++ users;
  "vin/RGNet-cert.age".publicKeys = [ vin ] ++ users;

}
