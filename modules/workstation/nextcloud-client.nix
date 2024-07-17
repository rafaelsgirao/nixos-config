_: {
  hm.services.nextcloud-client.enable = true;

  environment.persistence."/state".users.rg.directories = [ ".config/Nextcloud" ];
}
