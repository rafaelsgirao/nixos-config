_: {

  services.flatpak.enable = true;

  environment.persistence."/state" = {
    directories = [ "/var/lib/flatpak" ];
    users.rg.directories = [
      ".var"

      ".local/share/flatpak"
    ];

  };
}
