{ config, options, lib, pkgs, ... }:

let

  cfg = config.services.ssh-tpm-agent;
  socket = "ssh-tpm-agent";


in
{
  #  meta.maintainers = [ lib.maintainers.lheckemann ];

  options = {
    services.ssh-tpm-agent = {
      enable = lib.mkEnableOption "SSH TPM private key agent";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.ssh-tpm-agent" pkgs
        lib.platforms.linux)
    ];

    #    home.sessionVariablesExtra = ''
    #      if [[ -z "$SSH_AUTH_SOCK" ]]; then
    #        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
    #      fi
    #    '';
    #Force-override, because HM's services.ssh-agent (and NixOS's programs.ssh.startAgent) also set this.
    home.sessionVariables."SSH_AUTH_SOCK" = lib.mkForce "$XDG_RUNTIME_DIR/${socket}";
    home.packages = [ pkgs.ssh-tpm-agent ]; # For managing the agent/creating keys.

    systemd.user.services.ssh-tpm-agent = {
      #Copied from ssh-tpm-agent --install-user-units

      Unit = {
        ConditionEnvironment = "!SSH_AGENT_PID";
        Description = "ssh-tpm-agent service";
        Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
        Requires = [ "ssh-tpm-agent.socket" ];
      };

      Service = {
        Environment = "'SSH_AUTH_SOCK=%t/${socket}'";
        ExecStart = "${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent -l %t/${socket}";
        PassEnvironment = "SSH_AGENT_PID";
        SuccessExitStatus = "2";
        Type = "simple";
      };
      Install = {
        Also = [ "ssh-tpm-agent.socket" ];
      };
    };
    systemd.user.sockets."ssh-tpm-agent" = {
      #Copied from ssh-tpm-agent --install-user-units
      Unit = {
        Description = "SSH TPM agent socket";
        Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
      };
      Socket = {
        ListenStream = "%t/${socket}";
        SocketMode = "0600";
        Service = "ssh-tpm-agent.service";
      };
      Install = {
        WantedBy = [ "sockets.target" ];
      };

    };
  };
}
