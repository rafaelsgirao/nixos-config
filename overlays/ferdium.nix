_:
_final: prev:
let
  ferdiumPkg = prev.ferdium;
  ferdium-wrapper = prev.writeShellScriptBin "ferdium" ''
    #!${prev.bash}/bin/bash
    set -euo pipefail
    exec ${ferdiumPkg}/bin/ferdium --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform=wayland "$@"
  '';
in
{
  ferdium = prev.runCommand "ferdium-rg-wrapper"
    {
      buildInputs = [ ferdiumPkg ];
    } ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    cp -R ${ferdiumPkg}/share/applications/* $out/share/applications/
    # cat ${ferdium-wrapper}/bin/ferdium > $out/bin/ferdium
    cp ${ferdium-wrapper}/bin/ferdium $out/bin/ferdium

  '';
}
