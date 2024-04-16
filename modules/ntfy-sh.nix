{ config, lib, ... }:
let
  port = 50639;
  inherit (config.rg) domain;
  base-url = "https://push.${domain}";
in
{
  services.ntfy-sh.enable = true;
  services.ntfy-sh.settings = {
    inherit base-url;
    listen-http = ":${toString port}";
    attachment-cache-dir = "/var/cache/ntfy-sh/attachments";
    cache-file = "/var/cache/ntfy-sh/cache.db";
    cache-duration = "72h";
    behind-proxy = true;
    cache-batch-size = 25;
    auth-default-access = "write-only";
    cache-batch-timeout = "1s";
    cache-startup-queries = ''
      pragma journal_mode = WAL;
      pragma synchronous = normal;
      pragma temp_store = memory;
      pragma busy_timeout = 15000;
      vacuum;
    '';

  };
  systemd.services.ntfy-sh.serviceConfig = {
    DynamicUser = lib.mkForce false;
    CacheDirectory = "ntfy-sh";
  };

  services.caddy.virtualHosts."${base-url}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${builtins.toString port}
    '';
  };

  environment.persistence."/pst".directories = [
    "/var/lib/ntfy-sh"
  ];

  environment.persistence."/state".directories = [
    "/var/cache/ntfy-sh"
  ];

}
