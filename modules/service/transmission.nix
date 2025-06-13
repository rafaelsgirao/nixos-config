{
  config,
  hostSecretsDir,
  ...
}:
let
  port = 21018;
  inherit (config.rg) domain;
in

{
  services.transmission = {
    enable = true;
    # incomplete theme.
    # webHome = "${pkgs.flood-for-transmission}";
    openPeerPorts = true;
    credentialsFile = config.age.secrets.Transmission-creds.path;
    performanceNetParameters = true;
    settings = {
      peer-limit-global = 1000;
      rpc-port = port;
      rpc-bind-address = "127.0.0.1";
      rpc-username = "rg";
      rpc-authentication-required = true;

      watch-dir-enabled = true;
      watch-dir = "/pst/data/torrent_files";
      start-added-torrents = false;

      speed-limit-up-enabled = true;
      speed-limit-down-enabled = true;

      speed-limit-up = 100000;
      speed-limit-down = 100000;
    };

  };

  services.caddy.virtualHosts."transmission.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString port}
    '';
  };

  environment.persistence."/state".directories = [ "/var/lib/transmission" ];

  age.secrets.Transmission-creds = {
    file = "${hostSecretsDir}/Transmission-creds.age";
  };
}
