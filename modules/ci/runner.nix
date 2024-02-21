_:
# let
#   hostname = config.networking.hostName;
#   inherit (config.rg) ip;
#   inherit (config.networking) fqdn;
#   appName = "Gitea RG";
# in
{

  age.secrets = {
    ENV-woodpecker = {
      file = "${hostSecretsDir}/ENV-woodpecker.age";
    };
  };

  services.woodpecker-agents.agents.runner = {
    enable = true;
    path = with pkgs; [ coreutils git config.nix.package woodpecker-plugin-git ];
    environment = {
      WOODPECKER_BACKEND = "docker";
      WOODPECKER_SERVER = "127.0.0.1:${builtins.toString grpcPort}";
      WOODPECKER_BACKEND_DOCKER_VOLUMES = "/mnt/nix:/nix"
        # WOODPECKER_AUTHENTICATE_PUBLIC_REPOS = "true";

        };
      environmentFile = [ config.age.secrets.ENV-woodpecker.path ];
    };

  }
