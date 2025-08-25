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
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

}
