{
  config,
  pkgs,
  hostSecretsDir,
  ...
}:
let
  redisPort = 48485;
  port = 11826;
  inherit (config.networking) fqdn;
  inherit (config.rg) domain;
in
{
  # Adapted from
  # https://bitmagnet.io/setup/installation.html

  users.groups.bitmagnet = { };

  users.users.bitmagnet = {
    isSystemUser = true;
    group = "bitmagnet";
  };

  age.secrets = {
    ENV-bitmagnet = {
      file = "${hostSecretsDir}/ENV-bitmagnet.age";
      owner = "bitmagnet";
    };
  };

  services.redis.servers."bitmagnet" = {
    enable = true;
    user = "bitmagnet";
    port = redisPort;
  };

  environment.persistence."/state".directories = [ "/var/lib/redis-bitmagnet" ];

  systemd.services.bitmagnet = {
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      POSTGRES_HOST = "/run/postgresql";
      POSTGRES_NAME = "bitmagnet";
      POSTGRES_USER = "bitmagnet";

      #Remove when bitmagnet @ nixpkgs is at 0.7.0
      REDIS_ADDR = "127.0.0.1:${builtins.toString redisPort}";
      HTTP_SERVER_LOCAL_ADDRESS = "127.0.0.1:${builtins.toString port}";
    };

    serviceConfig = {
      # DynamicUser = true;
      User = "bitmagnet";
      ExecStart = "${pkgs.bitmagnet}/bin/bitmagnet worker run --keys=http_server --keys=queue_server --keys=dht_crawler";
      # ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "30s";

      EnvironmentFile = config.age.secrets.ENV-bitmagnet.path;

      # Hardening

      CapabilityBoundingSet = [ "" ];
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
      SystemcallErrorNumber = "EPERM";
      PrivateDevices = true;
      PrivateIPC = true;
      ProtectProc = "invisible";
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectHostname = true;
      ProtectClock = true;
      RestrictAddressFamilies = [ "AF_INET AF_INET6 AF_UNIX" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      PrivateUsers = true;
      ProtectControlGroups = true;
      ProcSubset = "pid";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      #Otherwise it fails with a message, regarding CoreCLR
      ProtectHome = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "/library" ];
      RestrictSUIDSGID = true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "bitmagnet" ];
    ensureUsers = [
      {
        name = "bitmagnet";
        ensureDBOwnership = true;
      }
    ];
  };

  services.caddy.virtualHosts."bitmagnet.${fqdn}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${builtins.toString port}
    '';
  };

  networking.firewall.allowedTCPPorts = [

    # 3333 # API and WebUI port
    3334 # BitTorrent ports
  ];

  networking.firewall.allowedUDPPorts = [ 3334 ];

  environment.systemPackages = [ pkgs.bitmagnet ];

}
