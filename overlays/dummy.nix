{ self, ... }:
_final: prev:
{
  fakepkg = prev.callPackage (self + "/packages/dummy/default.nix") { };
}
