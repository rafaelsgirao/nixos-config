{
  config,
  options,
  lib,
  ...
}:
let
  inherit (lib)
    mkAliasDefinitions
    mkOption
    types
    mkEnableOption
    ;
in
{
  options = {
    hm = mkOption { type = types.attrs; };
    rg = {
      enable = mkEnableOption "rg";
      machineType = mkOption {
        type = types.enum [
          "virt"
          "intel"
          "amd"
          "mac"
        ];
      };
      class = mkOption {
        type = types.enum [
          "workstation"
          "server"
        ];
      };

      isBuilder = mkOption {
        type = types.bool;
        default = false;
      };
      domain = mkOption { type = types.str; };
      backupsProvider = mkOption { type = types.str; };
      ip = mkOption { type = types.str; };
      ipv4 = mkOption { type = types.str; };
      ipv6 = mkOption { type = types.str; };

    };

  };
  config = {
    home-manager.users."rg" = mkAliasDefinitions options.hm;

    assertions = [
    ];
  };

}
