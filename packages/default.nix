{
  pkgs,
  inputs',
  ...
}:
let
  inherit (pkgs) callPackage;
in
rec {

  #Packages from inputs.
  agenix = inputs'.agenix.packages.default;
  disko = inputs'.disko.packages.default;
  bolsas-scraper = inputs'.bolsas-scraper.packages.default;
  wc-bot = inputs'.wc-bot.packages.default;
  #TODO.
  # remarkable-rcu = pkgs.callPackage ./rcu {};
  # TODO: broken.
  # ist-discord-bot = inputs'.ist-discord-bot.packages.default;

  #Packages defined in this repo.
  exo = pkgs.callPackage ./exo { };
  fakepkg = pkgs.callPackage ./fakepkg { };
  http-cat = pkgs.callPackage ./http-cat { };

  flatpak-xdg-utils = pkgs.callPackage ./flatpak-xdg-utils { };

  howdy = pkgs.callPackage ./howdy { };

  go-vod = callPackage ./go-vod { };

  drawj2d = callPackage ./drawj2d { };

  # chef-workstation = callPackage ./chef-workstation { inherit rubyNix; };

  octodns = pkgs.callPackage ./octodns { };
  octodns-cloudflare = pkgs.callPackage ./octodns-cloudflare { inherit octodns; };

  pyinstaller = pkgs.callPackage ./pyinstaller { inherit (pkgs) python3; };

  mailrise = pkgs.callPackage ./mailrise { inherit (pkgs) python3; };

  refind-ursamajor-theme = pkgs.callPackage ./refind-ursamajor-theme { };

  lyricsgenius = pkgs.callPackage ./lyricsgenius { inherit (pkgs) python3; };
  tidal-dl = pkgs.callPackage ./tidal-dl {
    inherit (pkgs) python3;
    inherit lyricsgenius;
  };

  pre-commit-macadmin = pkgs.callPackage ./pre-commit-macadmin { inherit (pkgs) python3; };

  isponsorblocktv = pkgs.callPackage ./isponsorblock { inherit (pkgs) python3; };

  # Scripts
  noisedropper = pkgs.callPackage ./scripts/noisedropper.nix { };
  python-scripts = pkgs.callPackage ./scripts { inherit (pkgs) python3; };
  randomport = pkgs.callPackage ./scripts/randomport.nix { };

  # Packages mostly to contribute upstream
  unFTP = callPackage ./contrib/unFTP { };
  sunshine = pkgs.callPackage ./contrib/sunshine { };
}
