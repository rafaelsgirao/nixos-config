# This should apply to any chromium-based browser (e.g, brave).
# Surprisingly, it also works on Flatpaked Brave!
# https://github.com/flathub/com.brave.Browser/blob/master/brave.sh

{ config, ... }: {

  imports = [ ];
  programs.chromium = {
    enable = true;
    extraOpts = {
      # Policies that can be set here can be found by going to about:policy and selecting "Show policies with no value set"
      # "AuthServerAllowlist" = "id.tecnico.ulisboa.pt";
      # "DisableAuthNegotiateCnameLookup" = true;
      "PasswordManagerEnabled" = false;
      "BrowserSignin" = false;
      "AllowDinosaurEasterEgg" = false;
      "BrowserAddPersonEnabled" = false;
      "BrowserGuestModeEnabled" = false;
      "BuiltInDnsClientEnabled" =
        false; # Disabling this in hopes of disabling internal chrome DNS caching. but no idea
      # "ClearBrowsingDataOnExitList" = [  ]; - doesn't do anything to option in options
      "3rdparty"."extensions" = {
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" = {
          # uBlock Origin
          #   #   # "toOverwrite"."userFilters" = "! 2022-10-21 https://meta.stackoverflow.com\n###hot-network-questions\n"; - replaced with custom list
          #   #   #TODO: Check if userFilters is a valid thing
          #   #   "toOverwrite"."filterLists" = [
          #   #
          #   #     #Privacy
          #   #     "adguard-spyware"
          #   #     "adguard-spyware-url" # Privacy->Adguard URL Tracking Protection
          #   #     "block-lan" # Block Outsider Intrusion into LAN
          #   #
          #   #     #Ads
          #   #     "adguard-generic"
          #   #
          #   #     #Annoyances
          #   #     "adguard-annoyance"
          #   #     "adguard-social"
          #   #
          #   #     #Malware domains
          #   #     "curben-pup" # PUP Domains blocklist
          #   #     "curben-phishing" # Malwra
          #   #
          #   #     "user-filters"
          #   #     "ublock-filters"
          #   #     "ublock-badware"
          #   #     "ublock-privacy"
          #   #     "ublock-quick-fixes"
          #   #     "ublock-abuse"
          #   #     "ublock-unbreak"
          #   #     "easylist"
          #   #     "easyprivacy"
          #   #     "urlhaus-1"
          #   #     "fanboy-cookiemonster" # - Great alternative to I don't care about cookies
          #   #     "plowe-0"
          #   #     "spa-1" # - Adguard Spanish/Portuguese filters
          #   #     "https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/google_duckduckgo/all.txt"
          #   #     "https://raw.githubusercontent.com/brunomiguel/antinonio/master/antinonio.txt"
          #   #     "https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/all_search_engines/global.txt"
          #   #     "https://rafael.ovh/rg_ublock.txt"
          #   #   ];
          #   # };
          "nngceckbapebfimnlniiiahkandclblb" = {
            #Bitwarden
            "environment"."base" = "https://vault.rafael.ovh";
          };
        };
      };

      # Ungoogled chromium completely breaks auto extension update behaviour, even if you specify the link
      # See the patches in their repo
      # extensions = [
      #   "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx" # uBlock Origin

      # ];
      # extensions = [
      #   "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        #   "gbmgphmejlcoihgedabhgjdkcahacjlj" # Wallabagger
        #   "ocgpenflpmgnfapjedencafcfakcekcd" # Redirector
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        # #      "oladmjdebphlnjjcnomfhhbfdldiimaf" # LibRedirect #TODO: not on web store :(
        # ];
        };

        # nixpkgs.config = { chromium = { enableWideVine = true; }; };

        #Firejail!
        # environment.systemPackages = with pkgs; [ ungoogled-chromium ];
        }

