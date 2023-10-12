_:
_final: prev:
let
  ferdium-wrapper = prev.writeShellScriptBin "ferdium" ''
    #!${prev.bash}/bin/bash
    set -euo pipefail
    exec ${prev.unstable.ferdium}/bin/ferdium --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform=wayland "$@"
  '';
in
{
  ferdium = prev.runCommand "ferdium-rg-wrapper"
    {
      buildInputs = [ prev.ferdium ];
    } ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    cp -R ${prev.unstable.ferdium}/share/applications/* $out/share/applications/
    # cat ${ferdium-wrapper}/bin/ferdium > $out/bin/ferdium
    cp ${ferdium-wrapper}/bin/ferdium $out/bin/ferdium

  '';
}
