_: {
  services.desktopManager.cosmic.enable = true;
  # Disable cosmic-greeter ; continue using GDM
  # services.displayManager.cosmic-greeter.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

}
