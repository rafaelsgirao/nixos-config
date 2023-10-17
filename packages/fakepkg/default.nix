{ stdenv
, pkgs
, ...
}:
stdenv.mkDerivation {
  name = "fakepkg";
  builder = pkgs.writeShellScript "fakepkg" ''
    ${pkgs.bash}/bin/bash
    ${pkgs.busybox}/bin/mkdir $out
    ${pkgs.busybox}/bin/touch $out/nothing-here
    exec -a ${pkgs.busybox}/bin/true
  '';
}
