{
  lib,
  pkgs,
  inputs',
  system,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs) callPackage;
  # Don't add this flake as an input because it's a private repo
  # and nixos-install won't run without being able to fetch all inputs.
  # a better solution would be flake.parts partitions.
  wcFlake = builtins.getFlake "git+https://git.rsg.ovh/mirrors/ist-chan-bot.git?ref=main&rev=6c5fef87f30390d6595aaae225686615f1ec892a";
in
(rec {
  #Packages from inputs.
  agenix = inputs'.agenix.packages.default;
  disko = inputs'.disko.packages.default;
  bolsas-scraper = inputs'.bolsas-scraper.packages.default;

  #TODO.
  # remarkable-rcu = pkgs.callPackage ./rcu {};
  # TODO: broken.
  # ist-discord-bot = inputs'.ist-discord-bot.packages.default;

  #Packages defined in this repo.
  fakepkg = pkgs.callPackage ./fakepkg { };
  http-cat = pkgs.callPackage ./http-cat { };

  howdy = pkgs.callPackage ./howdy { };

  go-vod = callPackage ./go-vod { };

  drawj2d = callPackage ./drawj2d { };

  # chef-workstation = callPackage ./chef-workstation { inherit rubyNix; };

  mailrise = pkgs.callPackage ./mailrise { inherit (pkgs) python3; };

  refind-ursamajor-theme = pkgs.callPackage ./refind-ursamajor-theme { };

  pre-commit-macadmin = pkgs.callPackage ./pre-commit-macadmin { inherit (pkgs) python3; };

  isponsorblocktv = pkgs.callPackage ./isponsorblock { inherit (pkgs) python3; };
  secrets-check = pkgs.callPackage ./secrets-check { };

  # Scripts
  noisedropper = pkgs.callPackage ./scripts/noisedropper.nix { };
  python-scripts = pkgs.callPackage ./scripts { inherit (pkgs) python3; };
  randomport = pkgs.callPackage ./scripts/randomport.nix { };
}
// lib.optionalAttrs (system == "aarch64-darwin") { nix-darwin = inputs'.nix-darwin.packages.default; }
// lib.optionalAttrs (system != "aarch64-darwin") {
  wc-bot = wcFlake.packages.${pkgs.system}.default;
}
)
