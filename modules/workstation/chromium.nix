# This should apply to any chromium-based browser (e.g, brave).
# Surprisingly, it also works on Flatpaked Brave!
# https://github.com/flathub/com.brave.Browser/blob/master/brave.sh

{ ... }: {

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
      # Disabling this in hopes of disabling internal chromium DNS caching, fingers crossed:
      "BuiltInDnsClientEnabled" = false;
      "3rdparty"."extensions" = {
        "nngceckbapebfimnlniiiahkandclblb" = {
          #Bitwarden
          "environment"."base" = "https://vault.rafael.ovh";
        };
      };
      # Brave-specific policies.
      "BraveAIChatEnabled" = false;
      "BraveRewardsDisabled" = true;
      "BraveVPNDisabled" = true;
      "BraveWalletDisabled" = true;
      "BraveShieldsEnabledForUrls" = [ ];
    };

    # Must-have extensions. I may add others manually & just use Brave Sync
    extensions = [
      "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    ];
  };

  # nixpkgs.config = { chromium = { enableWideVine = true; }; };
}

