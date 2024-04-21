{ lib, pkgs, inputs, ... }: {
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
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
