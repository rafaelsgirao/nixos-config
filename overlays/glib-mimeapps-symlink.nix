_: _final: prev: {
  glib = prev.glib.overrideAttrs (attrs: {
    patches = attrs.patches ++ [
      ../files/mimeapps_list_resolve_symlinks.patch
    ];
  });
}
