{ config, ... }: {
  services.caddy = {
    enable = true;
    email = config.security.acme.defaults.email;
  };

}
