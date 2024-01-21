{ pkgs, config, ... }:
{

  hm.services.darkman = {
    enable = true;
    settings = {
      usegeoclue = false; # This being true causes the location icon in gnome to always be visible.
      lat = config.location.latitude;
      lng = config.location.longitude;
    };

    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
      # my-python-script = pkgs.writers.writePython3 "my-python-script" { } ''
      #   print('Do something!')
      # '';
    };
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
      # my-python-script = pkgs.writers.writePython3 "my-python-script" { } ''
      #   print('Do something!')
      # '';
      # };

    };
  };
}
