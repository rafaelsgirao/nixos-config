_: _final: prev: {
  my_qemu = prev.unstable.qemu.overrideAttrs (attrs: {
    patches = attrs.patches ++ [
      (prev.fetchpatch {
        url = "https://raw.githubusercontent.com/Scrut1ny/Hypervisor-Phantom/refs/heads/main/Hypervisor-Phantom/patches/QEMU/amd-qemu-9.2.0.patch";
        hash = "sha256-BbzgjRa3qaYH1yXXqU6M/S68SxXWpAc9ObTG5qXu6YA=";
        revert = true;
      })

    ];
  });
}
