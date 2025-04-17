{ config, ... }:
let
  inherit (config.networking) domain;
  port = 53545;
in
{
  services.thelounge = {
    enable = true;
    public = false;
    inherit port;
    extraConfig = {
      reverseProxy = true;
      messageStorage = [
        "text"
        "sqlite"
      ];
      # defaults = {
      #   name = "Your Network";
      #   host = "localhost";
      #   port = 6697;
      # };

    };

  };

  services.caddy.virtualHosts."irc.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [ "/var/lib/thelounge" ];

}
