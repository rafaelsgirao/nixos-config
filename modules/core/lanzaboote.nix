{ lib, pkgs, inputs, ... }: {
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.

  #README rg: follow this guide before enabling this on a 
  # new machine!
  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  # TL;DR: sudo sbctl create-keys first, then enable and rebuild boot to configuration,
  # and then do sbctl verify. Only if all OK then should secureboot be enabled
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  environment.systemPackages = [ pkgs.sbctl ];

  environment.persistence."/pst" = {
    directories =
      [
        "/etc/secureboot"
      ];
  };
}
