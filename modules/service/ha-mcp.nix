{
  config,
  pkgs,
  hostSecretsDir,
  ...
}:
# DISABLED: not imported in hosts/razer/machine.nix. This runs `ha-mcp-web`,
# whose only auth is the secret URL path (capability URL) — we chose the
# authenticated built-in `mcp_server` integration instead. Keep this around to
# revisit as an OAuth 2.1 server: switch ExecStart to `${pkgs.unstable.ha-mcp}/bin/ha-mcp-oauth`
# (per-user HA-token consent, needs MCP_BASE_URL) before re-enabling.
let
  # Streamable-HTTP transport (ha-mcp-web / main_web). Binds 0.0.0.0:8086; the
  # firewall is not opened, so reach it via a reverse proxy / tailnet only.
  port = 8086;
in
{
  systemd.services.ha-mcp = {
    description = "Home Assistant MCP server (streamable-HTTP)";
    after = [
      "network-online.target"
      "home-assistant.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    # Non-secret config as plain env; HOMEASSISTANT_TOKEN and MCP_SECRET_PATH
    # come from the agenix EnvironmentFile below so they stay out of the store.
    environment = {
      HOMEASSISTANT_URL = "http://127.0.0.1:8123";
      MCP_PORT = toString port;
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.unstable.ha-mcp}/bin/ha-mcp-web";
      EnvironmentFile = config.age.secrets.ENV-ha-mcp.path;
      Restart = "on-failure";
      RestartSec = "10s";

      # Stateless: no config/state on disk, only outbound HTTP to HA + inbound MCP.
      DynamicUser = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      CapabilityBoundingSet = "";
      SystemCallArchitectures = "native";
      UMask = "0077";
    };
  };

  age.secrets.ENV-ha-mcp = {
    file = "${hostSecretsDir}/ENV-ha-mcp.age";
  };
}
