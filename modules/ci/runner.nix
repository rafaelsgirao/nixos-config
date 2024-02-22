{ config'
, pkgs
, ...
}:
let
  inherit (config'.rg) ip;
  grpcPort = 32467;
in
{



  services.woodpecker-agents.agents.runner = {
    enable = true;
    path = with pkgs; [ coreutils git config'.nix.package woodpecker-plugin-git ];
    environment = {
      WOODPECKER_BACKEND = "docker";
      WOODPECKER_SERVER = "${ip}:${builtins.toString grpcPort}";
      WOODPECKER_BACKEND_DOCKER_VOLUMES = "/mnt/nix:/nix";
      # WOODPECKER_BACKEND_DOCKER_NETWORK = "bridge";
      # WOODPECKER_AUTHENTICATE_PUBLIC_REPOS = "true";

    };
    environmentFile = [ config'.age.secrets.ENV-woodpecker.path ];
  };
  systemd.services."woodpecker-agent-runner".serviceConfig = {
    SupplementaryGroups = [ "docker" ];
  };

}
