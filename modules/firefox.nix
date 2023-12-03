{ pkgs, ... }:

{

  hm.programs.firefox = {
    enable = true;

    package = pkgs.mypkgs.fakepkg;
    profiles."rg" = {
      #   extraConfig = ''
      # '';

      search.force = true;
      search.default = "StartPage";
      search.engines = {
        "Arch Wiki" = {
          urls = [{
            template = "https://wiki.archlinux.org/index.php";
            params = [
              # { name = "title"; value = "Special"; }
              { name = "search"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/distributor-logo-archlinux.svg";
          definedAliases = [ "!aw" ];
        };
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "!nixp" ];
        };
        # defaultSearchProviderSearchURL = "https://startpage.com/search?query={searchTerms}";
        "StartPage" = {
          urls = [{
            template = "https://startpage.com/search";
            params = [
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          # icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "!sp" ];
        };

        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "!nix" ];
        };

        "Bing".metaData.hidden = true;
        "Google".metaData.alias = "!g"; # builtin engines only support specifying one additional alias
      };
      settings = {

        # force hardware decoding
        "media.ffmpeg.vaapi.enabled" = true;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "network.negotiate-auth.trusted-uris" = "id.tecnico.ulisboa.pt";

        # IMPORTANT: Start your code on the 2nd line
        "app.normandy.api_url" = "";
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.update.auto" = false;
        "beacon.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.aboutConfig.showWarning" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.disableResetPrompt" = true;
        "browser.fixup.alternate.enabled" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.safebrowsing.appRepURL" = "";
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.selfsupport.url" = "";
        "browser.send_pings" = false;
        "browser.sessionstore.privacy_level" = "0";
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.tabs.firefox-view" = false;
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.urlbar.trimURLs" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "device.sensors.ambientLight.enabled" = false;
        "device.sensors.enabled" = false;
        "device.sensors.motion.enabled" = false;
        "device.sensors.orientation.enabled" = false;
        "device.sensors.proximity.enabled" = false;
        "dom.battery.enabled" = false;
        # Needed for copy pasting into sites. Duh.
        "dom.event.clipboardevents.enabled" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;
        "extensions.autoDisableScopes" = "14";
        "extensions.getAddons.cache.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.greasemonkey.stats.optedin" = false;
        "extensions.greasemonkey.stats.url" = "";
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.api_url" = "";
        "extensions.shield-recipe-client.enabled" = false;
        "extensions.webservice.discoverURL" = "";
        "media.autoplay.default" = "1";
        "media.autoplay.enabled" = false;
        "media.eme.enabled" = false;
        "media.video_stats.enabled" = false;
        "network.IDN_show_punycode" = true;
        "network.allow-experiments" = false;
        "network.cookie.cookieBehavior" = "1";
        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.http.referer.XOriginPolicy" = "2";
        "network.http.speculative-parallel-limit" = "0";
        "network.predictor.enable-prefetch" = false;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "network.trr.mode" = "5";
        "pdfjs.enableScripting" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = "1";
        "privacy.firstparty.isolate" = true;
        "privacy.query_stripping" = true;
        # pref("privacy.resistFingerprinting", true);
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.usercontext.about_newtab_segregation.enabled" = true;
        "security.ssl.disable_session_identifiers" = true;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
        "signon.autofillForms" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.cachedClientID" = "";
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = "2";
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "webgl.renderer-string-override" = " ";
        "webgl.vendor-string-override" = " ";
        # Betterfox settings
        "geo.provider.use_gpsd" = false;
        "geo.provider.use_geoclue" = false;
        "browser.discovery.enabled" = false;
        "default-browser-agent.enabled" = false;
        # Smoothfox
        "mousewheel.default.delta_multiplier_y" = "275";
        # -------------------Fastfox
        # PREF: initial paint delay
        # How long FF will wait before rendering the page, in milliseconds
        # Reduce the 5ms Firefox waits to render the page
        # [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1283302
        # [2] https://docs.google.com/document/d/1BvCoZzk2_rNZx3u9ESPoFjSADRI0zIPeJRXFLwWXx_4/edit#heading=h.28ki6m8dg30z
        "nglayout.initialpaint.delay" = "0";
        "nglayout.initialpaint.delay_in_oopif" = "0";
        # PREF: notification interval (in microseconds) [to avoid layout thrashing]
        # When Firefox is loading a page, it periodically reformats
        # or "reflows" the page as it loads. The page displays new elements
        # every 0.12 seconds by default. These redraws increase the total page load time.
        # The default value provides good incremental display of content
        # without causing an increase in page load time.
        # [NOTE] Lowering the interval will increase responsiveness
        # but also increase the total load time.
        # [WARNING] If this value is set below 1/10 of a second, it starts
        # to impact page load performance.
        # [EXAMPLE] 100000 = .10s = 100 reflows/second
        # [1] https://searchfox.org/mozilla-central/rev/c1180ea13e73eb985a49b15c0d90e977a1aa919c/modules/libpref/init/StaticPrefList.yaml#1824-1834
        # [2] https://dev.opera.com/articles/efficient-javascript/?page=3#reflow
        # [3] https://dev.opera.com/articles/efficient-javascript/?page=3#smoothspeed
        "content.notify.interval" = "100000";
        # PREF: disable preSkeletonUI on startup
        "browser.startup.preXulSkeletonUI" = false;
        # PREF: Webrender tweaks
        # [1] https://searchfox.org/mozilla-central/rev/6e6332bbd3dd6926acce3ce6d32664eab4f837e5/modules/libpref/init/StaticPrefList.yaml#6202-6219
        # [2] https://hacks.mozilla.org/2017/10/the-whole-web-at-maximum-fps-how-webrender-gets-rid-of-jank/
        # [3] https://www.troddit.com/r/firefox/comments/tbphok/is_setting_gfxwebrenderprecacheshaders_to_true/i0bxs2r/
        # [4] https://www.troddit.com/r/firefox/comments/z5auzi/comment/ixw65gb?context=3
        "gfx.webrender.all" = true;
        "gfx.webrender.precache-shaders" = true;
        "gfx.webrender.compositor" = true;
        "layers.gpu-process.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        # PREF: GPU-accelerated Canvas2D
        # [WARNING] May break PDF rendering on Surface Pro devices [2]
        # [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1739448
        # [2] https://github.com/yokoffing/Betterfox/issues/153
        "gfx.canvas.accelerated" = true;
        "gfx.canvas.accelerated.cache-items" = "32768";
        "gfx.canvas.accelerated.cache-size" = "4096";
        "gfx.content.skia-font-cache-size" = "80";
        # PREF: image tweaks
        "image.cache.size" = "10485760";
        "image.mem.decode_bytes_at_a_time" = "131072";
        "image.mem.shared.unmap.min_expiration_ms" = "120000";
        # PREF: increase media cache
        "media.memory_cache_max_size" = "1048576";
        "media.memory_caches_combined_limit_kb" = "2560000";
        # PREF: decrease video buffering
        # [NOTE] Does not affect videos over 720p since they use DASH playback [1]
        # [1] https://lifehacker.com/preload-entire-youtube-videos-by-disabling-dash-playbac-1186454034
        "media.cache_readahead_limit" = "9000";
        "media.cache_resume_threshold" = "6000";
        "browser.cache.memory.max_entry_size" = "153600";
        # PREF: use bigger packets
        # [1] https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74561.html
        # [2] https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74570.html
        "network.buffer.cache.size" = "262144";
        "network.buffer.cache.count" = "128";
        # PREF: increase the absolute number of HTTP connections
        # [1] https://kb.mozillazine.org/Network.http.max-connections
        # [2] https://kb.mozillazine.org/Network.http.max-persistent-connections-per-server
        # [3] https://old.reddit.com/r/firefox/comments/11m2yuh/how_do_i_make_firefox_use_more_of_my_900_megabit/jbfmru6/
        "network.http.max-connections" = "1800";
        "network.http.max-persistent-connections-per-server" = "10";
        # PREF: increase TLS token caching
        "network.ssl_tokens_cache_capacity" = "32768";
      };
    };
  };

  programs.firefox =
    let
      # custom-firefox = pkgs.firefox.override {
      #   # See nixpkgs' firefox/wrapper.nix to check which options you can use
      #   cfg = {
      #     # Gnome shell native connector
      #     enableGnomeExtensions = true;
      #   };
      # };

    in
    {
      # package = pkgs.fakepkg;
      # package = (pkgs.busybox +;
      enable = true;
      package = pkgs.firefox;
      # package = custom-firefox;
      policies = {
        "3rdparty".Extensions = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            environment = {
              base = "https://vault.rafael.ovh";
            };
          };
        };
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DNSOverHTTPS = {
          Enabled = false;
          Locked = true;
        };

        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = true;
        };
        DisableTelemetry = true;
        PasswordManagerEnabled = false;

        UserMessaging = {
          # WhatsNew = false;
          ExtensionRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = false;
          MoreFromMozilla = false;
        };
        FirefoxHome = {
          # Search = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          SponsoredTopSites = false;
        };
        ExtensionSettings =
          builtins.mapAttrs
            (
              _name: value: {
                installation_mode = "normal_installed";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${value}/latest.xpi";
              }
            )
            {
              "uBlock0@raymondhill.net" = "ublock-origin";
              "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = "localcdn-fork-of-decentraleyes";
              "addon@darkreader.org" = "darkreader";
              "7esoorv3@alefvanoon.anonaddy.me" = "libredirect";
              "CookieAutoDelete@kennydo.com" = "cookie-autodelete";
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
              "jsr@javascriptrestrictor" = "javascript-restrictor";
              "@contain-facebook" = "facebook-container";
              "{48748554-4c01-49e8-94af-79662bf34d50}" = "privacy-pass";
              #This list is not up to date. IDC: firefox account does the job
            };
        OfferToSaveLogins = false;
        SearchSuggestEnabled = false;
        ShowHomeButton = false;
        Homepage = {
          URL = "about:blank";
          StartPage = "none";
        };
      };
    };
}
