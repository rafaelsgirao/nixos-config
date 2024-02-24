{ config
, pkgs
, ...
}:
let
  grpcPort = 32467;
in
{

  services.woodpecker-agents.agents.runner = {
    enable = true;
    package = pkgs.unstable.woodpecker-agent;
    path = with pkgs; [ bash coreutils git git-lfs config.nix.package woodpecker-plugin-git ];
    environment = {
      WOODPECKER_BACKEND = "docker";
      WOODPECKER_SERVER = "ci.spy.rafael.ovh:${builtins.toString grpcPort}";
      WOODPECKER_BACKEND_DOCKER_VOLUMES = "/nix:/mnt/nix:ro";
      # WOODPECKER_BACKEND_DOCKER_NETWORK = "bridge";
      # WOODPECKER_AUTHENTICATE_PUBLIC_REPOS = "true";

    };
    environmentFile = [ "/run/woodpecker-secrets/ENV-woodpecker" ];
  };
  systemd.services."woodpecker-agent-runner".serviceConfig = {
    SupplementaryGroups = [ "docker" ];
  };

}
