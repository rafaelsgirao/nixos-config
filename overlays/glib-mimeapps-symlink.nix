_: _final: _prev: {
  # Disabled because requires re-building world
  # Apparently a LOT of things depend on glib.

  # glib = prev.glib.overrideAttrs (attrs: {
  #   patches = attrs.patches ++ [
  #     ../files/mimeapps_list_resolve_symlinks.patch
  #   ];
  # });

  # Failed attempts to mitigate this:
  #
  #
  # nextcloud-client = prev.nextcloud-client;
  # qt5 = { webengine = prev.qt5.qtwebengine; } // prev.qt5;
  # qt6Packages = { qtwebengine = prev.qt6Packages.qtwebengine; } // prev.qt6Packages;

  #  # elements of pkgs.gnome must be taken from gfinal and gprev
  #   qt6Packages = prev.qt6Packages.overrideScope (gfinal: gprev: {
  #     qtwebengine = gprev.qtwebengine;
  # });
}
