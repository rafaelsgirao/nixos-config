{
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
    };
  };

  age.secrets.ENV-forgejo-runner = {
    file = "${hostSecretsDir}/ENV-forgejo-runner.age";
    mode = "440";
    # group = "forgejo-runner";
  };
}
