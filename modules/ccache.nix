{ config, pkgs, ... }:
{

  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  programs.ccache = {
    enable = true;
    # Scopes ccache per-package; a global stdenv override would rehash the
    # bootstrap and lose binary cache substitution everywhere.
    packageNames = [
      # Not `linuxPackages_jovian`: that's a package set with no .override.
      # Jovian's overlay does `linuxPackages_jovian = linuxPackagesFor
      # final.linux_jovian`, so overriding the kernel reaches the set.
      "linux_jovian"

      # Attr names, not derivation names: `mesa-radv-jupiter` builds
      # mesa-26.2.0.steamos, and plain `mesa` is a different package that
      # substitutes from cache and never gets built here.
      # "mesa-radeonsi-jupiter"
      "mesa-radv-jupiter"

      # "gamescope"
      # "gamescope-wsi"
    ];
  };

  # Ownership must match the ccache module's tmpfiles rule. Impermanence's
  # defaults (0755 root:root) would shadow it with an unwritable bind mount,
  # and the ccache wrapper aborts the build if $CCACHE_DIR is not writable.
  environment.persistence."/state".directories = [
    {
      directory = config.programs.ccache.cacheDir;
      user = "root";
      group = "nixbld";
      mode = "0770";
    }
  ];

  # ccache's 5G default evicts itself during a kernel build. `nix-ccache` can't
  # set this -- it only permits -C/-V/-s/-z.
  systemd.tmpfiles.rules = [
    "f+ ${config.programs.ccache.cacheDir}/ccache.conf 0660 root nixbld - max_size = 60G"
  ];

  environment.systemPackages = [ pkgs.ccache ];

}
