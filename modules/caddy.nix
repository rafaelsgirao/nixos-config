{ config, ... }: {
  services.caddy = {
    enable = true;
    inherit (config.security.acme.defaults) email;
  };

}
