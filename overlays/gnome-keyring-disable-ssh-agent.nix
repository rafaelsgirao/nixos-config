_: _final: prev: {
  # gnome = prev.gnome.overrideScope (
  #   _gfinal: gprev: {
  #     gnome-keyring = gprev.gnome-keyring.overrideAttrs (oldAttrs: {
  #       configureFlags = oldAttrs.configureFlags or [ ] ++ [ "--disable-ssh-agent" ];
  #     });
  #   }
  # );

  gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags or [ ] ++ [ "--disable-ssh-agent" ];
  });
}
