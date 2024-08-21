{ config, ... }:
let
  stateDir = "${config.services.kubo.dataDir}";
in

{

  environment.persistence."/pst".directories = [
    { directory = stateDir; user = "ipfs"; group = "ipfs"; mode = "700"; }
  ];

  services.kubo = {
    enable = true;
    dataDir = "/var/lib/ipfs";
    settings = {

      Addresses.Gateway = "/ip4/127.0.0.1/tcp/12545";
      Datastore = {
        StorageMax = "1GB";
        enableGC = true;
      };
      Discovery = {
        MDNS = {
          Enabled = false;
        };
      };
      Swarm = {
        AddrFilters = null;
      };
    };
  };
}
