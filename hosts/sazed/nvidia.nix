{ lib, ... }:
let
  IDs = [
    "10de:2184"
    "10de:1aeb"
    "10de:1aec"
    "10de:1aed"
  ];
in

{
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"

      # "nvidia"
      # "nvidia_modeset"
      # "nvidia_uvm"
      # "nvidia_drm"
    ];

    kernelParams =
      [
        # enable IOMMU
        "amd_iommu=on"
      ]
      ++
      # isolate the GPU
      ("vfio-pci.ids=" + lib.concatStringsSep "," IDs);
  };

  # hardware.opengl.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
