{ pkgs, lib, config, ... }:
let
  isGnome = config.services.xserver.desktopManager.gnome.enable;
in
{

  #maybe later.
  # environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  hm.home.packages = with pkgs; [
    wl-clipboard
    wl-clipboard-x11
  ]
  ++ lib.optionals (!isGnome) [
    wdisplays
  ];

  environment.systemPackages = with pkgs; [
  ];




  hm.services.mako = mkIf (!isGnome) {
    enable = true;
    defaultTimeout = 10000;
  };

  hm.services.wlsunset = mkIf (!isGnome) {
    enable = true;
    latitude = "38.7223";
    longitude = "9.1393";
  };
}
