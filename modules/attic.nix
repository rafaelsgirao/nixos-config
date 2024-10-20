{
  config,
  hostSecretsDir,
  inputs,
  ...
}:
let
  port = toString 33763;
  dbUser = config.services.atticd.user;
  host = "cache.${config.rg.domain}";

in
{
  imports = [ inputs.attic.nixosModules.atticd ];

  age.secrets = {
    ENV-attic = {
      file = "${hostSecretsDir}/ENV-attic.age";
    };
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = dbUser;
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ dbUser ];
  };

  services.atticd = {
    enable = true;
    credentialsFile = config.age.secrets.ENV-attic.path;
    settings = {
      allowed-hosts = [ host ];
      api-endpoint = "https://${host}/";
      soft-delete-caches = false;
      require-proof-of-possession = false;

      database.url = "postgresql:///${dbUser}";

      compression = {
        type = "zstd";
      };

      storage = {
        type = "local";
        path = "/var/lib/atticd"; # service is DynamicUser
      };

      garbage-collection = {
        interval = "7 days";
        default-retention-period = "6 months";
      };

      listen = "${config.rg.ip}:${port}";
      chunking = {
        # The minimum NAR size to trigger chunking
        #
        # If 0, chunking is disabled entirely for newly-uploaded NARs.
        # If 1, all NARs are chunked.
        nar-size-threshold = 64 * 1024; # 64 KiB

        # The preferred minimum size of a chunk, in bytes
        min-size = 16 * 1024; # 16 KiB

        # The preferred average size of a chunk, in bytes
        avg-size = 64 * 1024; # 64 KiB

        # The preferred maximum size of a chunk, in bytes
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };

  environment.persistence."/state".directories = [
    #FIXME: /var/lib/private should also be mode 0700
    {
      directory = "/var/lib/private/atticd";
      mode = "0700";
    } # service is DynamicUser
  ];
  # The service above is supposed to detect this based on the database string,
  # but since we're using the shorthand, it doesn't.
  systemd.services.atticd.after = [
    "postgresql.service"
    "nss-lookup.target"
  ];

  services.caddy.virtualHosts."${host}" = {
    useACMEHost = "rafael.ovh";
    extraConfig = ''
      encode zstd gzip

      header {
          Strict-Transport-Security "max-age=2592000; includeSubDomains"
      }
      reverse_proxy http://${config.rg.ip}:${port}
        
    '';
  };

}
