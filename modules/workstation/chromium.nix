# This should apply to any chromium-based browser (e.g, brave).
# Surprisingly, it also works on Flatpaked Brave!
# https://github.com/flathub/com.brave.Browser/blob/master/brave.sh

{ ... }:
{

  imports = [ ];

  environment.etc = {
    # TODO: consider opening upstream issue to do this by default
    # Without doing this, Flatpak'ed Brave wouldn't be able to see these files
    # (i.e, the real files in the Nix store.
    "brave/policies/managed/default.json".mode = "0444";
    "brave/policies/managed/extra.json".mode = "0444";
  };

  programs.chromium = {
    enable = true;
    extraOpts = {
      # Policies that can be set here can be found by going to about:policy and selecting "Show policies with no value set"
      # "AuthServerAllowlist" = "id.tecnico.ulisboa.pt";
      # "DisableAuthNegotiateCnameLookup" = true;
      "TorDisabled" = true;
      "SideSearchEnabled" = false;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
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
      # "IPFSEnabled" = false;

    };

    # Must-have extensions. I may add others manually & just use Brave Sync
    extensions = [
      "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
      # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin - trying to use just brave shields
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    ];
  };

  # nixpkgs.config = { chromium = { enableWideVine = true; }; };
}
