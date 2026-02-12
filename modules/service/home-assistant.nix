{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) domain;
  port = config.services.home-assistant.config.http.server_port;
in
{
  services.home-assistant = {
    enable = true;

    package = pkgs.unstable.home-assistant.overrideAttrs (_oldAttrs: {
      doInstallCheck = false;
    });
    extraPackages =
      ps: with ps; [
        pkgs.ffmpeg
        # pytapo
      ];
    config = {

      http = {
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
    customComponents = with pkgs.unstable.home-assistant-custom-components; [
      auth_oidc
      better_thermostat
      # pkgs.mypkgs.tapo-control
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
      "default_config"
      "ffmpeg"
      # "bthome"
      # "ipp"
      "stream"
      "onvif"
      "matter"
      "thread"
      "otbr"
    ];

  };

  services.matter-server = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.matter-server.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "matter-server";
    Group = "matter-server";
  };

  users.groups.matter-server = { };

  users.users = {
    matter-server = {
      group = "matter-server";
      # extraGroups = [ "caddy" ];
      isSystemUser = true;
    };
  };

  services.caddy.virtualHosts."home.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [
    "/var/lib/hass"
    "/var/lib/matter-server"
  ];

  environment.systemPackages = with pkgs; [ ffmpeg ];
  systemd.services.home-assistant.path = [ pkgs.ffmpeg ];

}
