{ config, lib, pkgs, hostSecretsDir, ... }:

let
  configFile = pkgs.writeText "mailrise_config.yml" ''
    configs:
      '*@*':
        urls:
        - !env_var MAILRISE_MACHINES_URL
      'rss-ist@rafael.ovh':
        urls:
        - !env_var MAILRISE_RSS_IST_URL
      'rss-feeds@rafael.ovh':
        urls:
        - !env_var MAILRISE_RSS_FEEDS_URL
  '';

in
{
  systemd.services.mailrise = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "network-online.target" ];
    serviceConfig = {
      EnvironmentFile = config.age.secrets.ENV-mailrise.path;
      ExecStart = "${pkgs.mypkgs.mailrise}/bin/mailrise ${configFile}";
    };
  };

  age.secrets.ENV-mailrise = {
    file = "${hostSecretsDir}/../ENV-mailrise.age";
  };

  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/3-optional-configuration.html
  #Aliases to receive root mail
  environment.etc."aliases".text = lib.mkForce ''
    root: machines+root@${config.networking.fqdn}
    rg: machines+rg@${config.networking.fqdn}
  '';

  programs.msmtp.defaults = {
    port = 8025;
    tls = "off";
  };

  programs.msmtp.accounts.default = lib.mkForce {
    host = config.networking.fqdn;
    auth = false;
    from = "machines.${config.networking.hostName}@rafael.ovh";
    port = 8025;
    tls = false;
  };
}
