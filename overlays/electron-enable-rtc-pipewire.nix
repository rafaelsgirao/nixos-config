_:
_final: prev:
{
  # https://archive.fosdem.org/2023/schedule/event/om_chromium/attachments/slides/5503/export/events/attachments/om_chromium/slides/5503/FOSDEM2023_Modern_Camera_Handling_in_Chromium.pdf
  # https://webrtc-review.googlesource.com/c/src/+/261620/23/modules/video_capture/BUILD.gn
  electron = prev.electron.overrideAttrs (attrs: {
    gnFlags = attrs.gnFlags // { rtc_use_pipewire = true; }
      });
  }
