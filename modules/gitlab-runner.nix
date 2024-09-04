{ lib
, ...
}: {
  # enabling ip_forward on the host machine is important for the docker container to be able to perform networking tasks (such as cloning the gitlab repo)

  boot.kernel.sysctl."net.ipv4.ip_forward" = true; # 1

  services.gitlab-runner = {
    enable = true;
    clear-docker-cache.enable = true;
    gracefulTermination = true;
    gracefulTimeout = "5min 20s";
    services.rg-runner = {
      registrationConfigFile = "/pst/gitlab_runner.env";
      dockerDisableCache = true;
      dockerImage = "alpine";


    };
    # settings = {
    #    [[runners]]
    #    [runners.docker]
    #        host = "unix:///run/user/978/podman/podman.sock"
    #
    # };
  };

  users.users.gitlab-runner = {
    isNormalUser = true;
    uid = 1035;
    linger = true;

    # extraGroups = [
    #   "video"
    #   "input"
    #   "render"
    # ];
  };
  users.groups.gitlab-runner = { };

  systemd.services = {
    gitlab-runner = {
      environment = {
        "XDG_RUNTIME_DIR" = "/run/user/1035";

      };
      serviceConfig = {

        DynamicUser = lib.mkForce false;
        User = "gitlab-runner";
        Group = "gitlab-runner";
      };
    };
  };

  environment.persistence."/state".directories = [
    "/var/lib/gitlab-runner"
  ];
}
