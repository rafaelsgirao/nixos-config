{
  config,
  inputs,
  hostSecretsDir,
  ...
}:
let
  inherit (config.rg) domain;
  port = 29417;
in
{
  imports = [
    inputs.infra-keyval.nixosModules.infra-keyval
  ];

  services.infra-keyval = {
    inherit port;
    enable = true;
    configureDatabase = true;

    # WRITE_TOKEN=<token>
    settingsFile = config.age.secrets.ENV-infra-keyval.path;
  };

  age.secrets.ENV-infra-keyval = {
    file = "${hostSecretsDir}/ENV-infra-keyval.age";
    mode = "440";
    group = config.services.infra-keyval.group;
  };

  services.caddy.virtualHosts."keyval.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://[::1]:${toString port}
    '';
  };
}
