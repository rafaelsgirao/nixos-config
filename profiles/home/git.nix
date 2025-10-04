{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.git = {
    enable = true;
    aliases = {
      log = "log --show-signature";
      g = "log --all --graph --decorate --show-signature";
      graph = "log --all --graph --decorate --show-signature";
      s = "status";
      d = "diff";
    };
    delta.enable = true;
    lfs.enable = true;
    userEmail = lib.mkDefault "git@rafael.ovh";
    userName = "Rafael Girão";

    ignores = [
      "*~"
      "*.swp"

    ];
    extraConfig = {
      core = {
        editor = "nvim";
        whitespace = "warn";

      };
      blame = {
        ignoreRevsFile = ".git-blame-ignore-revs";
      };

      pull = {
        rebase = true;
      };
      delta = {
        navigate = true;
      };

      url = mkDefault {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@git.rsg.ovh:2222".insteadOf = "https://git.rsg.ovh/";
      };

      # SSH commit signing. See:
      # https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html
      gpg.ssh.allowedSignersFile = "${./../../files/allowed_signers}";

      commit.gpgSign = mkDefault true;
      gpg.format = "ssh";
      user = mkDefault {
        #`man ssh-keygen` reads:
        # -Y sign:
        #  The key used for signing is specified using the -f option and may refer to either a private key,
        #  or a public key with the private half available via ssh-agent(1).
        signingkey = "/home/rg/.ssh/id_gitsign.pub";
      };
    };
  };
}
