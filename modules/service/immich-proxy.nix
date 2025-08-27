{ config, ... }:
let
  inherit (config.networking) domain;
  port = 16498;
in
{

  services.caddy.virtualHosts."fotos.rafael.ovh" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy localhost:${builtins.toString port}
    '';
  };

  services.immich-public-proxy = {
    enable = true;
    immichUrl = "https://immich.${domain}";
    inherit port;

    settings = {
      singleImageGallery = true;
      downloadOriginalPhoto = true;
      showGalleryTitle = true;
      showHomePage = false;
      allowDownloadAll = 1;
    };

  };

}
