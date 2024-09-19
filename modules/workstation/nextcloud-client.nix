{ lib, ... }: {
  hm.services.nextcloud-client.enable = true;

  environment.persistence."/state".users.rg.directories = [ ".config/Nextcloud" ];


  # https://discourse.nixos.org/t/nextcloud-client-does-not-auto-start-in-gnome3/46492/7
  systemd.user.services.nextcloud-client = {
    Unit = {
      After = lib.mkForce "graphical-session.target";
    };
  };
}
