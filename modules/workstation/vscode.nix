{ pkgs, ... }:
{
  hm.programs.vscode =
    let
      p = pkgs.unstable;
    in
    {
      enable = true;
      package = p.vscode;

    };

  environment.persistence."/state".users.rg = {
    # files = [
    # ];
    directories = [
      ".vscode"
      ".config/Code"
    ];
  };
}
