{
  config,
  hostSecretsDir,
  pkgs,
  ...
}:
let
  port = 21018;
  inherit (config.rg) domain;
in

{
  services.transmission = {
    enable = true;
    webHome = "${pkgs.flood-for-transmission}";
    openPeerPorts = true;
    credentialsFile = config.age.secrets.Transmission-creds.path;
    performanceNetParameters = true;
    settings = {
      peer-port = 1844;
      peer-limit-global = 1000;
      rpc-port = port;
      rpc-bind-address = "127.0.0.1";
      rpc-username = "rg";
      rpc-authentication-required = true;
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
    # mode = "440";
    # owner = config.users.users.vaultwarden.name;
    # group = config.users.groups.vaultwarden.name;
  };
}
