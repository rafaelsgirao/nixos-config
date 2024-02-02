{ config, ... }:
let
  # inherit (config.rg) domain;
  hostname = "id.${config.rg.domain}";
  port = toString 44387;
  uri = "https://${hostname}";
in
{
  environment.persistence."/pst".directories = [ "/var/lib/kanidm" ];

  # age.secrets.ACME-env = {
  #   file = "${hostSecretsDir}/../ACME-env.age";
  #   owner = "acme";
  #   group = "acme";
  #   mode = "440";
  # };

  systemd.tmpfiles.rules = [
    # "d /state/backups 0705 root root -"
    "d /state/backups/kanidm 0700 kanidm kanidm -"
  ];

  # To access ACME certs
  systemd.services."kanidm".serviceConfig = {
    SupplementaryGroups = [ "caddy" ];
    BindPaths = [ "/state/backups/kanidm" ];
  };

  services.kanidm = {
    # enableServer = true;
    serverSettings = {
      bindaddress = "127.0.0.1:${port}";
      ldapbindaddress = "${config.rg.ip}:636";
      trust_x_forward_for = true;
      db_fs_type = "zfs"; #NOTE: don't forget to change dataset's recordsize to 64k!
      tls_chain = "/var/lib/acme/${config.rg.domain}/fullchain.pem";
      tls_key = "/var/lib/acme/${config.rg.domain}/key.pem";
      domain = hostname;
      origin = uri;
      online_backup = {
        path = "/state/backups/kanidm";
      };
    };
    clientSettings = {
      inherit uri;
    };

  };

  services.caddy.virtualHosts = {
    "${hostname}" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy {
            to https://127.0.0.1:${port}
            transport http {
                tls
                tls_insecure_skip_verify
            }
        }
      '';
    };
  };

}
