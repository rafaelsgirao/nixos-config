# Taken and adapted from nixrnl @ RNL:
# https://gitlab.rnl.tecnico.ulisboa.pt/rnl/nixrnl/
{ lib, ... }:
let

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
          # would be nice to have both, but don't think nix allows this.
          # if (type == "regular") || (type == "directory" && builtins.pathExists (path + "/default.nix")) then
          if (type == "regular") then
            path
          # recurse on directories that don't contain a `default.nix`
          else
            rakeLeaves path;
      };

      files = lib.filterAttrs sieve (builtins.readDir dirPath);
    in
    lib.filterAttrs (_n: v: v != { }) (lib.mapAttrs' collect files);

  /*
    *
    Synopsis: mkProfiles profilesDir

    Generate profiles from the Nix expressions found in the specified directory.

    Inputs:
    - profilesDir: The path to the directory containing Nix expressions.

    Output Format:
    An attribute set representing profiles.
    The function uses the `rakeLeaves` function to recursively collect Nix files
    and directories within the `profilesDir` directory.
    The result is an attribute set mapping Nix files and directories
    to their corresponding keys.

    *
  */

  # rakeLeaves Adopted from nixrnl: https://gitlab.rnl.tecnico.ulisboa.pt/rnl/nixrnl/
  mkProfiles = rakeLeaves;
in
{
  inherit rakeLeaves mkProfiles;
}
