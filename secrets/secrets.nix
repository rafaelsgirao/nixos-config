let

  keys = import ../keys.nix { };

  inherit (keys)
    users
    categories
    systems
    flattenKeys
    filterAgeKeys
    ;

  rgKeys = filterAgeKeys users.rg;
  mediaKeys = users.media;
  workstationsKeys = flattenKeys categories.workstations;
  # serversKeys = flattenKeys categories.servers;
  systemsKeys = flattenKeys systems;

in
{
  # Secrets for workstations.
  "RNLDEI-wireguard.age".publicKeys = workstationsKeys ++ rgKeys;
  "SSH-config.age".publicKeys = workstationsKeys ++ rgKeys;

  # Secrets for servers.
  # empty.

  # secrets for all.
  "restic-env.age".publicKeys = systemsKeys ++ rgKeys;
  "restic-password.age".publicKeys = systemsKeys ++ rgKeys;
  "ACME-env.age".publicKeys = systemsKeys ++ rgKeys;
  "sendmail-pass.age".publicKeys = systemsKeys ++ rgKeys;
  "rclone-config.age".publicKeys = systemsKeys ++ rgKeys;
  "ENV-mailrise.age".publicKeys = systemsKeys ++ rgKeys;
  "ENV-mediafederation.age".publicKeys = [
    systems.razer
  ]
  ++ rgKeys
  ++ mediaKeys;

  # razer secrets.
  "razer/ENV-forgejo-runner.age".publicKeys = [ systems.razer ] ++ rgKeys;
  # "razer/ENV-ha-mcp.age".publicKeys = [ systems.razer ] ++ rgKeys; # re-enable with ha-mcp.nix

  "razer/Tailscale-initrd-authkey.age".publicKeys = [ systems.razer ] ++ rgKeys;
  "razer/HC-alive.age".publicKeys = [ systems.razer ] ++ rgKeys;
  "razer/HC-backups.age".publicKeys = [ systems.razer ] ++ rgKeys;
  "razer/Nextcloud-adminpass.age".publicKeys = [ systems.razer ] ++ rgKeys;
  "harmonia-server.age".publicKeys = [ systems.razer ] ++ rgKeys;

  # saxton secrets.
  "saxton/ENV-ist-discord-bot.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-pocket-id.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-WCBot.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-bolsas-scraper.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/HC-alive.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-vaultwarden.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/Mailserver-pwd-rafael.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/Mailserver-pwd-machines.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/Caddy-super-secret-config.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-ott-rs.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ott-rs-client-token.age".publicKeys = [ systems.saxton ] ++ rgKeys;
  "saxton/ENV-oauth2-proxy.age".publicKeys = [ systems.saxton ] ++ rgKeys;
}
