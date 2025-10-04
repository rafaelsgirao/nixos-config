{ config, ... }:
{

  nix.distributedBuilds = !config.rg.isBuilder && config.rg.class == "workstation";
  nix.daemonIOSchedClass = "idle";
  nix.daemonCPUSchedPolicy = "idle";
  nix.settings.auto-optimise-store = true;

  nix.gc = lib.mkIf (!config.rg.isBuilder) {
    randomizedDelaySec = "45min";
    automatic = true;
    dates = "monthly";
    #Keep last 5 generations.
    options =
      let
        days = if config.rg.isBuilder then "120d" else "90d";
      in
      "--delete-older-than ${days}";
  };

}
