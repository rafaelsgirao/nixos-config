let

  keys = import ../keys.nix { };

  inherit (keys)
    users
    categories
    systems
    flattenKeys
    ;

  rgKeys = users.rg;
  mediaKeys = users.media;
  workstationsKeys = flattenKeys categories.workstations;
  # serversKeys = flattenKeys categories.servers;
  systemsKeys = flattenKeys systems;

in
{
  # Secrets for workstations.
  "RNLDEI-wireguard.age".publicKeys = workstationsKeys ++ rgKeys;
  "SSH-config.age".publicKeys = workstationsKeys ++ rgKeys;
  "attic-config.age".publicKeys = workstationsKeys ++ rgKeys;

  # Secrets for servers.
  # empty.

  # secrets for all.
  "restic-env.age".publicKeys = systemsKeys ++ rgKeys;
  "restic-password.age".publicKeys = systemsKeys ++ rgKeys;
  "wakatime-config.age".publicKeys = systemsKeys ++ rgKeys;
  "ACME-env.age".publicKeys = systemsKeys ++ rgKeys;
  "sendmail-pass.age".publicKeys = systemsKeys ++ rgKeys;
  "rclone-config.age".publicKeys = systemsKeys ++ rgKeys;
  "ENV-mailrise.age".publicKeys = systemsKeys ++ rgKeys;
  "ENV-mediafederation.age".publicKeys = [ systems.hoid ] ++ users ++ mediaKeys;

  # spy secrets.
  # "spy/ENV-attic.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # "spy/HC-alive.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # "spy/HC-nextcloud.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # "spy/HC-backups.age".publicKeys = [ systems.spy ] ++ rgKeys;
  "spy/Nextcloud-adminpass.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # "spy/Nextcloud-redispass.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # "spy/Nextcloud-secretfile.age".publicKeys = [ systems.spy ] ++ rgKeys;

  # hoid secrets.
  "hoid/ENV-attic.age".publicKeys = [ systems.hoid ] ++ rgKeys;
  "hoid/HC-alive.age".publicKeys = [ systems.hoid ] ++ rgKeys;
  "hoid/HC-nextcloud.age".publicKeys = [ systems.hoid ] ++ rgKeys;
  "hoid/HC-backups.age".publicKeys = [ systems.spy ] ++ rgKeys;
  "hoid/Nextcloud-adminpass.age".publicKeys = [ systems.hoid ] ++ rgKeys;
  "hoid/Transmission-creds.age".publicKeys = [ systems.hoid ] ++ rgKeys;
  # "spy/Nextcloud-redispass.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # "spy/Nextcloud-secretfile.age".publicKeys = [ systems.spy ] ++ rgKeys;
  # - attic cfg for builders: allows pushing store paths to my cache.
  "attic-config-builder.age".publicKeys = [ systems.hoid ] ++ rgKeys;

  # saxton secrets.
  "saxton/ENV-ist-discord-bot.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-WCBot.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-bolsas-scraper.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/HC-alive.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-vaultwarden.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/Mailserver-pwd-rafael.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/Mailserver-pwd-machines.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/Caddy-super-secret-config.age".publicKeys = [ systems.saxton ] ++ rgKeys;
}
