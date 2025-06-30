{ config, lib, ... }:
(lib.mkIf config.rg.enableCosmic {

  services.desktopManager.cosmic.enable = true;
  # Disable cosmic-greeter ; continue using GDM
  # services.displayManager.cosmic-greeter.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  environment.persistence."/pst".users.rg.directories = [ ".config/cosmic" ];

})
