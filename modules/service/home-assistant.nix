{ config, pkgs, ... }:
let
  inherit (config.networking) domain;
  port = config.services.home-assistant.config.http.server_port;
in
{
  services.home-assistant = {
    enable = true;
    config = {

      http = {
        server_host = [
          "127.0.0.1"
          "::1"
        ];
        trusted_proxies = [
          "::1"
          "127.0.0.1"
        ];
        use_x_forwarded_for = true;
      };
      homeassistant = {
        name = "Home";
        temperature_unit = "C";
        inherit (config.location) latitude longitude;
      };
      "automation nixos" = [
        # YAML automations go here
      ];
      "automation ui" = "!include automations.yaml";
    };
    customComponents = with pkgs.home-assistant-custom-components; [
      auth_oidc
      better_thermostat
      pkgs.mypkgs.tapo-control
    ];
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

      # rg: components required by local-network discovered devices
      "androidtv_remote"
      "cast"
      "homeassistant_sky_connect"
      "zha"

      # rg: other components
      "jellyfin"
      # sth sth eletricity map
      "co2signal"
      "mobile_app"
      "tplink"
      "apple_tv"
      # "bthome"
      # "ipp"
      "stream"
      "onvif"
    ];

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
