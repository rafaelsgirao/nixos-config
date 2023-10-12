{ stdenv
, pkgs
, ...
}:
stdenv.mkDerivation {
  name = "dummy";
  builder = pkgs.writeShellScript "dummy" ''
    ${pkgs.bash}/bin/bash
    ${pkgs.busybox}/bin/mkdir $out
    ${pkgs.busybox}/bin/touch $out/nothing-here
    exec -a ${pkgs.busybox}/bin/true
  '';
}
