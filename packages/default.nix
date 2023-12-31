{ pkgs, inputs, inputs', ... }:
let
  inherit (pkgs) callPackage;
  rubyNix = inputs.ruby-nix.lib pkgs;
in
rec {

  #Packages from inputs.
  bolsas-scraper = inputs'.bolsas-scraper.packages.default;
  sirpt-dnsbl = inputs'.sirpt-feed.packages.default;

  #TODO.
  # remarkable-rcu = pkgs.callPackage ./rcu {};

  ist-discord-bot = inputs'.ist-discord-bot.packages.default;

  #Packages defined in this repo.
  fakepkg = pkgs.callPackage ./fakepkg { };

  go-vod = callPackage ./go-vod { };
  # chef-workstation = callPackage (./chef-workstation {}).envMinimal;
  chef-workstation = callPackage ./chef-workstation { inherit rubyNix; };

  octodns = pkgs.callPackage ./octodns { };
  octodns-cloudflare = pkgs.callPackage ./octodns-cloudflare { inherit octodns; };
  wc-bot = inputs'.wc-bot.packages.default;
  #NOTE: I don't think creating packages that call inputs is good practice,
  #But I don't know how to do better
  # setupSecrets = callPackage ./setupsecrets { inherit inputs; };

  #I don't know how to put writeScriptBin in its own file...
  #The code above doesn't work for some reason
  setupSecrets = pkgs.writeScriptBin "setupSecrets" (inputs.dsi-setupsecrets + "setupSecrets");

  #For consistency's sake, both use python3 from unstable (but lyricsgenius doesn't need it)
  lyricsgenius = pkgs.callPackage ./lyricsgenius { inherit (pkgs.unstable) python3; };
  tidal-dl = pkgs.callPackage ./tidal-dl { inherit (pkgs.unstable) python3; inherit lyricsgenius; };

  unFTP = callPackage ./unFTP { };
  # chef-workstation = callPackage (./chef-workstation {}).envMinimal;
}
