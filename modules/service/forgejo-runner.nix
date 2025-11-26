{
  lib,
  pkgs,
  config,
  hostSecretsDir,
  ...
}:
{

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "monolith";
      url = "https://git.rsg.ovh";
      hostPackages = with pkgs; [
        attic-client
        nix

        # Packages that came by default.
        bash
        coreutils
        curl
        gawk
        gitMinimal
        gnused
        nodejs
        wget
      ];
      # Obtaining the path to the runner token file may differ
      # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
      tokenFile = config.age.secrets.ENV-forgejo-runner.path;
      labels = [
        # "ubuntu-latest:docker://node:16-bullseye"
        # "ubuntu-22.04:docker://node:16-bullseye"
        # "ubuntu-20.04:docker://node:16-bullseye"
        # "ubuntu-18.04:docker://node:16-buster"
        ## optionally provide native execution on the host:
        "native:host"
      ];
      settings.host = {
        workdir_parent = "/var/cache/gitea-runner-default";
      };
    };
  };

  systemd.services."gitea-runner-default".serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "forgejo-runner";
    CacheDirectory = "gitea-runner-default";
  };

  age.secrets.ENV-forgejo-runner = {
    file = "${hostSecretsDir}/ENV-forgejo-runner.age";
    mode = "440";
    # group = "forgejo-runner";
  };

  users.groups.forgejo-runner = { };

  users.users = {
    forgejo-runner = {
      group = "forgejo-runner";
      # extraGroups = [ "caddy" ];
      isSystemUser = true;
    };
  };
}
