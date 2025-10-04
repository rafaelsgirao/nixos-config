{ inputs, profiles, ... }:

{

  imports = [
  ];

  # TODOs:
  # use upstream nix instead of determinate
  # block outside caches

  home-manager.users.rg = {
    home.stateVersion = "25.05";
    home.sessionVariables = {
      SSH_AUTH_SOCK = "/Users/rg/.bitwarden-ssh-agent.sock";
    };
    imports = [
      inputs.mac-app-util.homeManagerModules.default

      profiles.home.workstation
    ];
  };

  system.stateVersion = 6;
}
