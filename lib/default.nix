{ lib, ... }:
let

  mkDisk =
    attrs:
    let
      # TODO: isBoot is hack to avoid both disks attempting to mount at /boot, which eval dislikes.
      # The best fix would be systemd-boot in NixOS supporting mirrored boot...
      inherit (attrs) poolName diskPath isBoot;
      extraCfg = lib.optionalAttrs (attrs ? "extraCfg") attrs.extraCfg;
    in
    extraCfg
    // {
      type = "disk";
      device = diskPath;
      content.type = "gpt";
      content.partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          priority = 1; # Needs to be first partition
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = lib.mkIf isBoot "/boot";
          };
        };
        # Maybe pool name should be an argument?
        "${poolName}" = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "${poolName}";
          };
        };
      };
    };

in
{
  rg = {
    inherit mkDisk;
  };

  rnl = import ./rnl.nix { inherit lib; };
}
