{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) domain;
  port = 16498;
  publicHost = "fotos.rafael.ovh";

  shp-proxy = inputs.shp-proxy.packages.${pkgs.stdenv.hostPlatform.system}.default;

  configFile = (pkgs.formats.toml { }).generate "shp-proxy.toml" {
    listen = "127.0.0.1:${toString port}";
    immich = {
      upstream = "https://immich.${domain}";
      public_url = "https://${publicHost}";
    };
    # Only safe because the listener is loopback-only behind Caddy, which
    # overwrites X-Forwarded-For from untrusted clients.
    client_ip.header = "x-forwarded-for";
  };
in
{

  services.caddy.virtualHosts.${publicHost} = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy localhost:${toString port}
    '';
  };

  systemd.services.shp-proxy = {
    description = "Allowlisting reverse proxy for Immich public shares";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = lib.escapeShellArgs [
        (lib.getExe shp-proxy)
        "--config"
        configFile
      ];
      Restart = "on-failure";
      RestartSec = "10s";
      DynamicUser = true;
      UMask = "0077";
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      CapabilityBoundingSet = "";
      SystemCallArchitectures = "native";
    };
  };

}
