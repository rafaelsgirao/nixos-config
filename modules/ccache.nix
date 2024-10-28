{ config, pkgs, ... }:
{

  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  programs.ccache = {
    enable = true;
    packageNames = [
      # "ffmpeg"

    ];
  };
  environment.persistence."/state".directories = [ "/var/cache/ccache" ];
  environment.systemPackages = [ pkgs.ccache ];

}
