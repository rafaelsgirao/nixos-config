{ config, ... }:
let
  inherit (lib) mkOption types;
in

{
  options = {
    rg = {

      # Generate a new one with: dbus-uuidgen
      machineId = mkOption {
        type = types.str;
        default = null;
      };
      resetRootFs = mkOption {
        type = types.bool;
        default = false;
      };
      #ugly
      resetRootFsPoolName = mkOption {
        type = types.str;
        default = "zpool";
      };
      vCores = mkOption {
        type = types.ints.u8;
        default = 0;
      };
    };

  };

  config = {

    nix.distributedBuilds = !config.rg.isBuilder && config.rg.class == "workstation";
    nix.daemonIOSchedClass = "idle";
    nix.daemonCPUSchedPolicy = "idle";
    nix.settings.auto-optimise-store = true;

    environment.systemPackages = with pkgs; [
      lshw
      mbuffer
      traceroute
    ];
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

    environment.etc.machine-id.text = config.rg.machineId;
    networking.hostId = builtins.substring 0 8 config.rg.machineId;

    assertions = [
      {
        assertion = config.rg.vCores != 0;
        message = "The option config.rg.vCores must be set.";
      }
    ];
  };
}
