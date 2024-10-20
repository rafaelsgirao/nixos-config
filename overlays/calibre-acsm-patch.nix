_: _final: prev: {
  # https://github.com/Leseratte10/acsm-calibre-plugin/issues/68#issuecomment-1760654174
  calibre = prev.calibre.overrideAttrs (attrs: {
    preFixup =
      builtins.replaceStrings
        [
          ''
            --prefix PYTHONPATH : $PYTHONPATH \
          ''
        ]
        [
          ''
            --prefix LD_LIBRARY_PATH : ${prev.libressl.out}/lib \
            --prefix PYTHONPATH : $PYTHONPATH \
          ''
        ]
        attrs.preFixup;
  });
}
