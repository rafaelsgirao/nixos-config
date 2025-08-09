{ pkgs, ... }:
{

  services.flatpak.enable = true;

  environment.persistence."/state" = {
    directories = [ "/var/lib/flatpak" ];
    users.rg.directories = [
      ".var"
      ".local/share/flatpak"
    ];

  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "network-online.target" ];
    after = [ "network-online.target"];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

}
