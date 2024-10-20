{ config, ... }:
{

  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  programs.ccache = {
    enable = true;
    cacheDir = "/state/var/cache/ccache";
    packageNames = [
      # "ffmpeg"

    ];
  };

}
