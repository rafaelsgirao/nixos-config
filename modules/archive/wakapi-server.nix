{ config, pkgs, ... }:
let
  inherit (config.networking) fqdn;
  host = "https://wakapi.${fqdn}";
  port = 32778;
  format = pkgs.formats.yaml { };
  settings = {
    env = "production";
    server = {
      listen_ipv4 = "127.0.0.1";
      inherit port;
      public_url = host;
    };
    app = {
      custom_languages = {
        vue = "Vue";
        jsx = "JSX";
        tsx = "TSX";
        cjs = "Javascript";
        ipynb = "Python";
        svelte = "Svelte";
        astro = "Astro";
      };
    };
    db = {
      name = "/var/lib/wakapi/wakapi.db";
    };
    security = {
      allow_signup = true; # TODO: disable
      disable_frontpage = false;
    };
    mail = {
      enabled = false;
    };
  };
  configFile = format.generate "config.yaml" settings;
in
{

  environment.persistence."/pst".directories = [ "/var/lib/wakapi" ];

  services.caddy.virtualHosts."${host}" = {
    useACMEHost = "rafael.ovh";
    extraConfig = ''
      encode zstd gzip

      header {
          Strict-Transport-Security "max-age=2592000; includeSubDomains"
      }
      reverse_proxy http://127.0.0.1:${toString port}
        
      @api path_regexp "^/api.*"
      @notapi not path_regexp "^/api.*"

      push @notapi /assets/vendor/source-sans-3.css
      push @notapi /assets/css/app.dist.css
      push @notapi /assets/vendor/petite-vue.min.js
      push @notapi /assets/vendor/chart.min.js
      push @notapi /assets/vendor/iconify.basic.min.js
      push @notapi /assets/js/icons.dist.js
      push @notapi /assets/js/base.js
      push @notapi /assets/images/logo.svg
    '';
  };

  users.users = {
    wakapi = {
      group = "wakapi";
      isSystemUser = true;
    };
  };

  users.groups.wakapi = { };

  #Wakapi Server
  # https://github.com/muety/wakapi/blob/master/etc/wakapi.service
  systemd.services.wakapi = {
    description = "Wakapi";

    startLimitIntervalSec = 400;
    after = [ "network.target" ];
    startLimitBurst = 3;
    environment = {
      # WAKAPI_DB_NAME = "/var/lib/wakapi/wakapi.db";
      # ENVIRONMENT = "production";
      # # WAKAPI_DISABLE_FRONTPAGE = "false"; #TODO: changeme?
      # WAKAPI_MAIL_ENABLED = "false";
      # WAKAPI_PORT = port;
      # WAKAPI_PUBLIC_URL = host;
    };
    serviceConfig = {
      User = "wakapi";
      Group = "wakapi";
      RuntimeDirectory = "wakapi"; # creates /run/wakapi, useful to place your socket file there
      StateDirectory = "wakapi";
      ExecStart = "${pkgs.wakapi}/bin/wakapi -config ${configFile}";

      # https://ma.ttias.be/auto-restart-crashed-service-systemd/
      Restart = "on-failure";
      RestartSec = "90s";

      #Security Hardening
      PrivateTmp = true;
      PrivateUsers = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = "tmpfs";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      PrivateDevices = true;
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      ProtectClock = true;
      RestrictSUIDSGID = true;
      ProtectHostname = true;
      ProtectProc = "invisible";
    };
  };
}
