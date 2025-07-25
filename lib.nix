{ lib, ... }:
let

  mkDisk = attrs: let
    # TODO: isBoot is hack to avoid both disks attempting to mount at /boot, which eval dislikes.
    # The best fix would be systemd-boot in NixOS supporting mirrored boot...
    inherit (attrs) poolName diskPath isBoot;
    extraCfg = lib.optionalAttrs (attrs ? "extraCfg") attrs.extraCfg;
  in
  ( extraCfg // {
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
    }
  );

  # rakeLeaves Adopted from nixrnl: https://gitlab.rnl.tecnico.ulisboa.pt/rnl/nixrnl/
  rakeLeaves =
    /*
      *
      Synopsis: rakeLeaves _path_

      Recursively collect the nix files of _path_ into attrs.

      Output Format:
      An attribute set where all `.nix` files and directories with `default.nix` in them
      are mapped to keys that are either the file with .nix stripped or the folder name.
      All other directories are recursed further into nested attribute sets with the same format.

      Example file structure:
      ```
      ./core/default.nix
      ./base.nix
      ./main/dev.nix
      ./main/os/default.nix
      ```

      Example output:
      ```
      {
      core = ./core;
      base = base.nix;
      main = {
      dev = ./main/dev.nix;
      os = ./main/os;
      };
      }
      ```
      *
    */
    dirPath:
    let
      sieve =
        file: type:
        # Only rake `.nix` files or directories
        (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory");

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value =
          let
            path = dirPath + "/${file}";
          in
          if (type == "regular") || (type == "directory" && builtins.pathExists (path + "/default.nix")) then
            path
          # recurse on directories that don't contain a `default.nix`
          else
            rakeLeaves path;
      };

      files = lib.filterAttrs sieve (builtins.readDir dirPath);
    in
    lib.filterAttrs (_n: v: v != { }) (lib.mapAttrs' collect files);
in
{
  rg = {
    inherit mkDisk;
  };

  rnl = {
    inherit rakeLeaves;
  };
}
