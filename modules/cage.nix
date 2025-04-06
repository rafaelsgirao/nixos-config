{ lib, pkgs, ... }:
let
  kodi = pkgs.kodi-wayland.withPackages (
    kodiPkgs: with kodiPkgs; [
      sendtokodi
      mediacccde
      sponsorblock
      trakt
      pvr-iptvsimple
      youtube
    ]
  );
in
{
  # Define a user account
  users.extraUsers.kodi.isNormalUser = true;
  services.cage.user = "kodi";
  services.cage.program = "${lib.getExe kodi}";
  services.cage.enable = true;
}
