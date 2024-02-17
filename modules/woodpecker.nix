{ config, pkgs, hostSecretsDir, ... }:
let
  inherit (config.networking) fqdn;
  inherit (config.rg) domain;
  port = 40153;
  grpcPort = 32467;
in
{

  age.secrets = {
    ENV-woodpecker = {
      file = "${hostSecretsDir}/ENV-woodpecker.age";
      owner = "bitmagnet";
    };
  };
  environment.persistence."/pst".directories = [
    "/var/lib/private/woodpecker-server"
  ];
  services.woodpecker-server = {
    enable = true;
    environment = {
      # WOODPECKER_OPEN=true;
      WOODPECKER_ADMIN = "rg";
      WOODPECKER_HOST = "https://ci.${fqdn}";
      WOODPECKER_SERVER_ADDR = "127.0.0.1:${builtins.toString port}";
      WOODPECKER_AUTHENTICATE_PUBLIC_REPOS = "true";
      WOODPECKER_GITEA = "true";
      WOODPECKER_GITEA_URL = "https://git.spy.rafael.ovh";
      WOODPECKER_GRPC_ADDR = "127.0.0.1:${builtins.toString grpcPort}";
    };
    environmentFile = config.age.secrets.ENV-woodpecker.path;
  };
  services.woodpecker-agents.agents.baremetal = {
    enable = true;
    environment = {
      WOODPECKER_BACKEND = "local";
      WOODPECKER_SERVER = "127.0.0.1:${builtins.toString port}";
      # DOCKER_HOST = "unix:///run/podman/podman.sock";

    };
    environmentFile = [ config.age.secrets.ENV-woodpecker.path ];
  };

  services.caddy.virtualHosts."ci.${fqdn}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${builtins.toString port}
    '';
  };
}
