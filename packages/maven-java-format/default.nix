{ stdenv, pkgs, ... }:

let
  pkgName = "maven-vscode-lsp-server";
in

stdenv.mkDerivation {
  # test
  name = pkgName;

  src = pkgs.mpv;
  installPhase = ''
    mkdir -p $out/bin
    #cp -R ${pkgs.mpv}/. $out/
    #ln -sf $out/bin/mpv $out/bin/${pkgName}
    ln -sf ${pkgs.mpv}/bin/mpv $out/bin/${pkgName}
  '';

}
