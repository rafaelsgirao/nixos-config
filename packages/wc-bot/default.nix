{ buildNpmPackage, lib, ... }:


buildNpmPackage {
  name = "wc-bot";
  # version = "1.0.0";

  src = builtins.fetchGit
    {
      # url = "git@github.com:ist-chan-bot-team/ist-chan-bot.git";
      url = "git+ssh://git@git.spy.rafael.ovh:4222/rg/ist-chan-bot.git";
      ref = "nix-support";
      rev = "77c58b0e58676803b5c4b5a5a0575799c658d705";
    };
  dontNpmBuild = true;

  npmDepsHash = "sha256-V1b9fHNVahioiDe+9Qi3SJ3xN4kRQJMIebRvzmcsVss";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = [ "--ignore-scripts" ];

  # NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    description = "Bot for WC Discord server";
  };
}
