{ pkgs, config, ... }:
let
  inherit (config.rg) domain;
  port = 30901;
in
{

  services.polaris = {
    enable = true;
    package = pkgs.mypkgs.polaris;
    inherit port;
    settings = {
      settings.reindex_every_n_seconds = 7 * 24 * 60 * 60; # weekly, default is 1800

      settings.album_art_pattern = "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";

      settings.mount_dirs = [
        {
          name = "RGMusic";
          source = "/var/music";
        }
      ];

    };

  };

  services.caddy.virtualHosts."music.${domain}" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://localhost:${toString port}
    '';
  };

  environment.persistence."/pst".directories = [
    "/var/lib/private/polaris"
    "/var/music"
  ];
}
