{ pkgs, inputs, inputs', ... }:
let
  inherit (pkgs) callPackage;
  rubyNix = inputs.ruby-nix.lib pkgs;
in
rec {

  #Packages from inputs.
  bolsas-scraper = inputs'.bolsas-scraper.packages.default;
  wc-bot = inputs'.wc-bot.packages.default;
  #TODO.
  # remarkable-rcu = pkgs.callPackage ./rcu {};
  # TODO: broken.
  # ist-discord-bot = inputs'.ist-discord-bot.packages.default;


  #Packages defined in this repo.
  fakepkg = pkgs.callPackage ./fakepkg { };

  flatpak-xdg-utils = pkgs.callPackage ./flatpak-xdg-utils { };

  go-vod = callPackage ./go-vod { };
  # chef-workstation = callPackage (./chef-workstation {}).envMinimal;
  chef-workstation = callPackage ./chef-workstation { inherit rubyNix; };

  octodns = pkgs.callPackage ./octodns { };
  octodns-cloudflare = pkgs.callPackage ./octodns-cloudflare { inherit octodns; };

  pyinstaller = pkgs.callPackage ./pyinstaller { inherit (pkgs) python3; };


  #For consistency's sake, both use python3 from unstable (but lyricsgenius doesn't need it)
  lyricsgenius = pkgs.callPackage ./lyricsgenius { inherit (pkgs.unstable) python3; };
  tidal-dl = pkgs.callPackage ./tidal-dl { inherit (pkgs.unstable) python3; inherit lyricsgenius; };

  pre-commit-macadmin = pkgs.callPackage ./pre-commit-macadmin { inherit (pkgs) python3; };

  # Packages mostly to contribute upstream
  unFTP = callPackage ./contrib/unFTP { };
  sunshine = pkgs.callPackage ./contrib/sunshine { };
}
