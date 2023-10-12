{ self, inputs, ... }:
final: prev:
{
  #Packages from inputs
  bolsas-scraper = inputs.bolsas-scraper.packages.${final.system}.default;
  sirpt-dnsbl = inputs.sirpt-feed.packages.${final.system}.default;

  #Packages from this repo
  remarkable-rcu = prev.callPackage (self + "/packages/rcu/default.nix") { };

  rubyNix = inputs.ruby-nix.lib prev;
  chef-workstation = (prev.callPackage (self + "/packages/chef-workstation/default.nix") { }).env;
  go-vod = prev.callPackage (self + "/packages/go-vod/default.nix") { };
  # setupSecrets = prev.callPackage (self + "/packages/setupsecrets/default.nix") { };
  setupSecrets = prev.writeScriptBin "setupSecrets" (inputs.dsi-setupsecrets + "setupSecrets");
  ferdium-app = prev.callPackage (self + "/packages/ferdium/default.nix") { };
}
