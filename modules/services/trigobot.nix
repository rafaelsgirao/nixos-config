{ config, hostSecretsDir, pkgs, ... }:

let
  group = "trigobot";

in
{

  age.secrets.ENV-trigobot = {
    file = "${hostSecretsDir}/ENV-trigobot.age";
    mode = "440";
    inherit group;

  };

  users.groups."${group}" = { };

  systemd.services.trigobot = {
    environment = { };
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      SupplementaryGroups = "${group}";
      ReadOnlyPaths = [ config.age.secrets.ENV-trigobot.path ];
      ProtectSystem = "strict";
      ExecStart =
        "${pkgs.mypkgs.trigobot}/bin/trigobot";
    };

  };

  systemd.services.backup-vaultwarden.serviceConfig = {
    UMask = "007";
  };

  environment.persistence."/pst".directories = [
    "/var/lib/private/trigobot"
  ];

}
