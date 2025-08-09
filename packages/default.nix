{
  pkgs,
  inputs',
  ...
}:
let
  inherit (pkgs) callPackage;
  # Don't add this flake as an input because it's a private repo 
  # and nixos-install won't run without being able to fetch all inputs.
  # a better solution would be flake.parts partitions.
  wcFlake = builtins.getFlake "git+ssh://git@github.com/ist-chan-bot-team/ist-chan-bot.git?ref=master&rev=6c5fef87f30390d6595aaae225686615f1ec892a";
in
rec {
  #Packages from inputs.
  agenix = inputs'.agenix.packages.default;
  disko = inputs'.disko.packages.default;
  bolsas-scraper = inputs'.bolsas-scraper.packages.default;
  wc-bot = wcFlake.packages.${pkgs.system}.default;
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
