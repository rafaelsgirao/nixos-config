{ lib, pkgs, nixosConfigurations, ... }:
let
  clusterNodes = lib.filterAttrs (_name: host: host.config.rg.clusterNode) nixosConfigurations;
  redisClusterAddrs = lib.mapAttrsToList (_name: host: "${host.config.rg.ip} 6379") clusterNodes;
in

{
  services.redis.package = pkgs.keydb;
  services.redis.servers."redis-juicefs" = {
    enable = true;
    openFirewall = true;
    settings = rec {

      server-threads = 2;
      active-replica = true;
      replicaof = redisClusterAddrs; # Lists in settings will be translated to duplicate entries in the final file.
      requirePass = "letmein!"; #TODO: change in prod to requirePassFile.
      masterAuth = requirePass; #TODO: change in prod to requirePassFile.
    };
  };

}
