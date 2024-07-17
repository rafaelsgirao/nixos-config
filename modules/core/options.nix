{ config, options, lib, ... }:
let
  inherit (lib) mkAliasDefinitions mkOption types mkEnableOption;
in
{
  options = {
    hm = mkOption { type = types.attrs; };
    rg = {
      enable = mkEnableOption "rg";
      machineType = mkOption {
        type = types.enum [ "virt" "intel" "amd" ];
      };
      class = mkOption {
        type = types.enum [ "workstation" "server" ];
      };

      isBuilder = mkOption {
        type = types.bool;
        default = false;
      };
      isLighthouse = mkOption {
        type = types.bool;
        default = false;
      };
      pubKey = mkOption {
        type = types.str;
        default = null;
      };
      # Generate a new one with: systemd-machine-id-setup
      machineId = mkOption {
        type = types.str;
        default = null;
      };
      domain = mkOption { type = types.str; };
      backupsProvider = mkOption { type = types.str; };
      ip = mkOption { type = types.str; };
      ipv4 = mkOption { type = types.str; };
      ipv6 = mkOption { type = types.str; };
      resetRootFs = mkOption {
        type = types.bool;
        default = false;
      };
      #ugly
      resetRootFsPoolName = mkOption {
        type = types.str;
        default = "zpool";
      };
    };

  };
  config = {
    home-manager.users."rg" = mkAliasDefinitions options.hm;

    environment.etc.machine-id.text = config.rg.machineId;
    networking.hostId = builtins.substring 0 8 config.rg.machineId;

    assertions =
      let
        rgMsg = x: "The option ${x} must have a value!";
        assertRgNotNull = x: { assertion = x != null; message = rgMsg x; };
      in
      [
        (assertRgNotNull config.rg.domain)
        # (assertRgNotNull config.hm.home.stateVersion)
        (assertRgNotNull config.system.stateVersion)
        (assertRgNotNull config.rg.ip)
        # (assertRgNotNull config.rg.ipv4)
        # (assertRgNotNull config.rg.ipv6)
        (assertRgNotNull config.rg.machineType)
        (assertRgNotNull config.rg.machineId)
        (assertRgNotNull config.rg.class)
        (assertRgNotNull config.rg.pubKey)

      ];
  };

}
