{
  config,
  pkgs,
  lib,
  hostSecretsDir,
  ...
}:
let
  inherit (config.networking) domain fqdn;
  ncHost = "cloud.${domain}";
  altHosts = [
    "cloud.${fqdn}"
    "share.rafael.ovh" # public share links, via shp-proxy on saxton
    "cloud.spy.rafael.ovh"
  ];
in
{

  age.secrets = {
    NC-adminpass = {
      file = "${hostSecretsDir}/Nextcloud-adminpass.age";
      owner = "nextcloud";
    };
    # NC-secretfile = {
    #   file = "${hostSecretsDir}/Nextcloud-secretfile.age";
    #   owner = "nextcloud";
    # };
  };
  #Nextcloud
  services.nextcloud = {
    enable = true;
    https = true;
    package = pkgs.nextcloud34;
    webfinger = true;
    hostName = ncHost;
    maxUploadSize = "0";
    configureRedis = true;
    enableImagemagick = false;
    #Makes sure that wherever this module is imported this variable is changed.
    home = lib.mkDefault null;
    # secretFile = config.age.secrets.NC-secretfile.path;
    phpOptions = {
      #  "The amount of memory used to store interned strings, in megabytes."
      "opcache.interned_strings_buffer" = "32";
    };
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminpassFile = config.age.secrets.NC-adminpass.path;
      adminuser = "rg";
    };
    #Use system's sendmail utility for e-mails
    settings = {
      # "A value of 1 e.g. will only run these background jobs between 01:00am UTC and 05:00am UTC".
      maintenance_window_start = 1;
      trusted_domains = altHosts;
      trusted_proxies = [
        "127.0.0.1"
      ];
      overwriteprotocol = "https";
      default_phone_region = "PT";
      #Enables imaginary support.
      enabledPreviewProviders = [
        "OC\\Preview\\Imaginary"
        "\\OC\\Preview\\Imaginary"
        "\\OC\\Preview\\Movie"
        "OC\\Preview\\Movie"
      ];
      preview_imaginary_url = "http://${config.services.imaginary.address}:${toString config.services.imaginary.port}";
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";
    };

    notify_push = {
      enable = true;
      bendDomainToLocalhost = true;
    };

    # extraApps = with config.services.nextcloud.package.packages.apps; {
    #   inherit calendar contacts deck tasks twofactor_webauthn;
    # };
    # extraAppsEnable = true;
  };

  systemd.services.nextcloud-notify_push.environment = {
    NEXTCLOUD_URL = lib.mkForce "http://127.0.0.1:23700/";
  };
  services.nginx.enableReload = true;

  users.users.nginx.extraGroups = [ "caddy" ];

  services.nginx.virtualHosts.${ncHost} = {
    useACMEHost = "${domain}";
    addSSL = true;

    listen = [
      {
        addr = "0.0.0.0";
        port = 23700;
      }
    ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        # ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES"; - deprecated
        ensureDBOwnership = true;
      }
    ];
  };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/nextcloud/with-postgresql-and-redis.nix
  # https://www.chvp.be/blog/unifiedpush-nextcloud-nixos/
  services.redis.vmOverCommit = true;

  environment.persistence."/state".directories = [ "/var/lib/redis-nextcloud" ];

  systemd.services."phpfpm-nextcloud".serviceConfig = {
    DeviceAllow = [ "/dev/dri/renderD128" ];
    SupplementaryGroups = [
      "render"
      "video"
    ];
  };
  # For debugging
  # systemd.services."phpfpm-nextcloud".path = with pkgs; [
  environment.systemPackages = with pkgs; [
    redis
  ];

  services.imaginary = {
    enable = true;
    settings.return-size = true;
  };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

}
