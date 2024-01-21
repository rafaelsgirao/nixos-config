_:
# let
#   hostname = config.networking.hostName;
#   inherit (config.rg) ip;
#   inherit (config.networking) fqdn;
#   appName = "Gitea RG";
# in
{

  services.gitea-actions-runner.instances.gitea-runner = {
    enable = true;
    name = "microvm-gitea-runner";
    url = "https://git.spy.rafael.ovh";

    labels = [
      # provide a debian base with nodejs for actions
      "debian-latest:docker://node:18-bullseye"
      # fake the ubuntu name, because node provides no ubuntu builds
      "ubuntu-latest:docker://node:18-bullseye"
      # provide native execution on the host
      "native:host"

    ];

  };

}
