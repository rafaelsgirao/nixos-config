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
      settings.runner = {
        capacity = 3;
        timeout = "6h";
      };
    };
  };

  systemd.services."gitea-runner-default".serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "forgejo-runner";
    CacheDirectory = "gitea-runner-default";

    # Only bounds the runner and its `nix build` clients -- the build itself is
    # nix-daemon's cgroup. capacity=3 means up to three concurrent evaluations,
    # each 2-3G. Past MemoryHigh the cgroup is reclaim-throttled, not killed, so
    # an undersized cap stalls jobs indefinitely instead of failing them.
    MemoryHigh = "10G";
    MemoryMax = "14G";
  };

  # Builds run in nix-daemon, so these must be daemon settings, not runner env.
  nix.settings = {
    connect-timeout = lib.mkForce 30;
    fallback = lib.mkForce false;
    stalled-download-timeout = 900;
    download-attempts = 10;
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
