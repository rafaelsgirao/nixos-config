{ config, pkgs, secretsDir, ... }:

let
  port = 12969;
in
{

  age.secrets.ENV-garage = {
    file = "${secretsDir}/cluster/ENV-garage.age";
    owner = "garage";
    group = "garage";
    mode = "440";
  };

  systemd.services.garage = {
    environment = {
      #Both these env vars can be generated with `openssl rand -hex 32`.
      GARAGE_RPC_SECRET = "e70adac6a99e82708199594e78d086e82f4b920743a2a793eaeafaf0bbd36207"; #TODO: regen when prod!  gitleaks:allow
      # GARAGE_ADMIN_TOKEN = "c26ce9070ff94c3246e71c9a068f823119c6798197519468b3bcddec6f34794b"; #TODO: move to agenix when prod gitleaks:allow
    };
    serviceConfig = {
      User = "garage";
      DynamicUser = false;
    };
  };

  services.garage = {
    enable = true;
    package = pkgs.garage_1_x;
    environmentFile = config.age.secrets.ENV-garage.path;
    settings = rec {
      # https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/
      replication_factor = 3;
      db_engine = "sqlite";
      disable_scrub = true;
      rpc_bind_addr = "${config.rg.ip}:${toString port}";
      rpc_public_addr = rpc_bind_addr;
      rpc_bind_outgoing = true;

      allow_world_readable_secrets = false;
      consul_discovery = {
        consul_http_addr = "http://127.0.0.1:8500";
        service_name = "garage-daemon";
      };
      s3_api = {
        api_bind_addr = "127.0.0.1:3900"; # Not setting to nebula IP to allow local clients to access it thru localhost
        s3_region = "garage";
        root_domain = ".s3.rafael.ovh";
      };
    };
  };

  users.groups.garage = { };

  users.users.garage = {
    group = "garage";
    #  extraGroups = [ "caddy" ];
    isSystemUser = true;
  };

  environment.persistence."/pst".directories = [
    { directory = "/var/lib/garage"; }
    # { directory = config.mailserver.dkimKeyDirectory; user = dkimUser; group = dkimUser; }
  ];

  networking.firewall.allowedTCPPorts = [
    port
  ];

}
