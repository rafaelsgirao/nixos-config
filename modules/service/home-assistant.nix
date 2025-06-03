{ config, ... }:
let
  inherit (config.networking) domain;
  port = config.services.home-assistant.config.http.server_port;
in
{
  services.home-assistant = {
    enable = true;
    config.http = {
      server_host = "127.0.0.1";
    };
    config.homeassistant = {
      name = "Home";
      temperature_unit = "C";
      inherit (config.location) latitude longitude;
    };
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    config.default_config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
    };

  };

  services.caddy.virtualHosts."home.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [ "/var/lib/hass" ];

}
