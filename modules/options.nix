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
      domain = mkOption { type = types.str; };
      ip = mkOption { type = types.str; };
      ipv4 = mkOption { type = types.str; };
      ipv6 = mkOption { type = types.str; };
    };

  };
  config = {
    home-manager.users.${user} = mkAliasDefinitions options.hm;

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
        (assertRgNotNull config.rg.class)

      ];
  };

}
