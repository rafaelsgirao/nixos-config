{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ccache;
  usesCcache = drv: drv.stdenv.cc.outPath == pkgs.ccacheWrapper.outPath;
  # The option only exists on hosts that import the dgx-spark module.
  isDgxSpark = config.hardware.dgx-spark.enable or false;
in
{

  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
  programs.ccache = {
    enable = true;
    # Scopes ccache per-package; a global stdenv override would rehash the
    # bootstrap and lose binary cache substitution everywhere.
    packageNames = [
      # Unused; keeps the module's ccacheWrapper config enabled.
      "linux_jovian"

      # Attr names, not derivation names: `mesa-radv-jupiter` builds
      # mesa-26.2.0.steamos, and plain `mesa` is a different package that
      # substitutes from cache and never gets built here.
      # "mesa-radeonsi-jupiter"
      # "mesa-radv-jupiter"

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

  # Jovian's packages live in the `jovianPackages` scope, which `packageNames`
  # can't reach. mkAfter: this has to run after Jovian's overlay defines it.
  nixpkgs.overlays = lib.mkAfter (
    [
      (final: prev: {
        jovianPackages = prev.jovianPackages.overrideScope (
          _jfinal: jprev: {
            linux = jprev.linux.override { stdenv = final.ccacheStdenv; };
            mesa-radv = jprev.mesa-radv.override { stdenv = final.ccacheStdenv; };
          }
        );
      })
    ]
    # The DGX Spark module calls `pkgs.buildLinux` inline rather than exposing a
    # kernel attr, so `packageNames` can't reach it; `buildLinux` takes `stdenv`.
    ++ lib.optionals isDgxSpark [
      (final: prev: {
        buildLinux = attrs: prev.buildLinux ({ stdenv = final.ccacheStdenv; } // attrs);
      })
    ]
  );

  assertions = [
    {
      # The module only configures ccacheWrapper while packageNames is non-empty.
      assertion = lib.hasInfix ''CCACHE_DIR="${cfg.cacheDir}"'' pkgs.ccacheWrapper.cc.buildCommand;
      message = "ccacheWrapper is not configured with CCACHE_DIR=${cfg.cacheDir}.";
    }
  ]
  ++ lib.optionals config.jovian.devices.steamdeck.enable [
    {
      assertion = usesCcache config.boot.kernelPackages.kernel;
      message = "The Steam Deck kernel is not built with ccacheStdenv.";
    }
    {
      assertion =
        builtins.elem pkgs.jovianPackages.mesa-radv config.hardware.graphics.extraPackages
        && usesCcache pkgs.jovianPackages.mesa-radv;
      message = "The installed jovianPackages.mesa-radv is not built with ccacheStdenv.";
    }
  ]
  ++ lib.optionals isDgxSpark [
    {
      assertion = usesCcache config.boot.kernelPackages.kernel;
      message = "The DGX Spark kernel is not built with ccacheStdenv.";
    }
  ];

}
