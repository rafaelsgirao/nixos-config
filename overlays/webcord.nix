_:
_final: prev:
let
  webcordPkg = prev.unstable.webcord;
  webcord-wrapper = prev.writeShellScriptBin "webcord" ''
    set -euo pipefail
    exec ${webcordPkg}/bin/webcord --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform=wayland "$@"
  '';
in
{
  webcord = prev.symlinkJoin {
    name = "webcord";
    paths = [
      webcord-wrapper
      webcordPkg
    ];
  };
}
