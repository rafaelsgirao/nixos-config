{ lib, ... }:
{
  hm.programs.nixvim.plugins = lib.mkForce { };

  # Add each flake input as a registry
  # To make nix3 commands consistent with the flake
  # Only adding each flake input to the registry in workstations,
  # Since all registries add ~200-400MB to each system's closure.
  nix.registry = lib.mkForce lib.mapAttrs (_: value: { flake = value; }) inputs;

}
