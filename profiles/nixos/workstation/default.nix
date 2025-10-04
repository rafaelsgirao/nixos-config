{ lib, ... }:
let
  hmLib = lib; # HACK: not sure if it works
in

{

  # Add each flake input as a registry
  # To make nix3 commands consistent with the flake
  # Only adding each flake input to the registry in workstations,
  # Since all registries add ~200-400MB to each system's closure.
  nix.registry = lib.mkForce lib.mapAttrs (_: value: { flake = value; }) inputs;

  hm.home.file =

    {
      ".config/fish/fish_history".source =
        hmLib.file.mkOutOfStoreSymlink "/state/home/rg/.config/fish/fish_history";
      ".config/mimeapps.list".source =
        hmLib.file.mkOutOfStoreSymlink "/state/home/rg/.config/mimeapps.list";

      # "Although deprecated, several applications still read/write to ~/.local/share/applications/mimeapps.list."
      # "To simplify maintenance, simply symlink it to ~/.config/mimeapps.list:"
      # ^ https://wiki.archlinux.org/title/XDG_MIME_Applications#mimeapps.list
      ".local/share/applications/mimeapps.list".source =
        hmLib.file.mkOutOfStoreSymlink "/home/rg/.config/mimeapps.list";
    };

}
