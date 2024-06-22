_:
_final: prev:
{
  # https://archive.fosdem.org/2023/schedule/event/om_chromium/attachments/slides/5503/export/events/attachments/om_chromium/slides/5503/FOSDEM2023_Modern_Camera_Handling_in_Chromium.pdf
  # https://webrtc-review.googlesource.com/c/src/+/261620/23/modules/video_capture/BUILD.gn
  gnome_pomodoro = prev.gnome.pomodoro.overrideAttrs (attrs: rec {
    # gnFlags = attrs.gnFlags // { rtc_use_pipewire = true; };

    version = "0.25.2";
    src = prev.fetchFromGitHub {
      owner = attrs.pname;
      repo = attrs.pname;
      rev = version;
      hash = "sha256-agRb5yzJ6McIhhbE092AZY4t8l81qOpwDhe/2Yj+bzw=";
    };

    patches = [
      # Our glib setup hooks moves GSettings schemas to a subdirectory to prevent conflicts.
      # We need to patch the build script so that the extension can find them.
      # (prev.substituteAll {
      #   src = ./gnome-pomodoro.patch;
      #   # src = . + "../files/gnome-pomodoro.patch" ;
      #   inherit (attrs) pname;
      #   inherit version;
      # })
    ];


  });
}
