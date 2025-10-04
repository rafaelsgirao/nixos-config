{ profiles, ... }:
{
  imports = with profiles.common; [
    nix
    options
  ];

  rg = {
    enable = true;
    domain = "rsg.ovh";
  };
}
