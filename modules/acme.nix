{ config, hostSecretsDir, ... }:
let
  inherit (config.rg) domain;
  inherit (config.networking) fqdn;
in
{
  environment.persistence."/state".directories = [ "/var/lib/acme" ];
  age.secrets.ACME-env = {
    file = "${hostSecretsDir}/../ACME-env.age";
    owner = "acme";
    group = "acme";
    mode = "440";
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsResolver = "1.1.1.1:53";
      email = "acme-admin@${domain}";
      credentialsFile = config.age.secrets.ACME-env.path;
      dnsProvider = "cloudflare";
    };
  };

  # users.users.nginx.extraGroups = [ "acme" ];
  systemd.services."blocky".serviceConfig.SupplementaryGroups =
    [ "caddy" ]; # For acme certificate

  #ACME + Caddy
  security.acme.certs."${domain}" = {
    domain = "${domain}";
    extraDomainNames = [ "*.${domain}" "*.${fqdn}" ];
  };

}
