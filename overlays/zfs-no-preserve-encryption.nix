_: _final: prev:
let
  patch = ../files/zfs-no-preserve-encryption.patch;
  addPatch = drv: drv.overrideAttrs (attrs: {
    patches = (attrs.patches or [ ]) ++ [ patch ];
  });
in
{
  zfs = addPatch prev.zfs;
  linuxPackages = prev.linuxPackages.extend (_: ksuper: {
    zfs_2_3 = addPatch ksuper.zfs_2_3;
  });
}
