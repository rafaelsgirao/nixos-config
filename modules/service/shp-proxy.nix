{
  config,
  inputs,
  ...
}:
let
  inherit (config.networking) domain;

  # Public hostnames, one listener each: both apps use `/s/...` share URLs.
  # Nextcloud on razer must trust this host (see hosts/razer/machine.nix) and
  # list `cloudHost` in its trusted_domains (modules/nextcloud.nix).
  fotosHost = "fotos.rafael.ovh";
  fotosPort = 16498;
  cloudHost = "cloud.rafael.ovh";
  cloudPort = 16499;

  vhost = port: {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy localhost:${toString port}
    '';
  };
in
{
  imports = [ inputs.shp-proxy.nixosModules.default ];

  services.shp-proxy = {
    enable = true;
    settings = {
      immich = {
        listen = "127.0.0.1:${toString fotosPort}";
        upstream = "https://immich.${domain}";
        public_url = "https://${fotosHost}";
      };
      nextcloud = {
        listen = "127.0.0.1:${toString cloudPort}";
        upstream = "https://cloud.${domain}";
        public_url = "https://${cloudHost}";
      };
      # Only safe because the listeners are loopback-only behind Caddy, which
      # overwrites X-Forwarded-For from untrusted clients.
      client_ip.header = "x-forwarded-for";
    };
  };

  services.caddy.virtualHosts = {
    ${fotosHost} = vhost fotosPort;
    ${cloudHost} = vhost cloudPort;
  };
}
