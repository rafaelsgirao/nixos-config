{ config, pkgs, lib, secretsDir, ... }:
let
  agePath = config.age.secrets.wakatime-cfg.path;
in
{

  age.secrets.wakatime-cfg = {
    file = "${secretsDir}/../wakatime-config.age";
    mode = "440";
    owner = "rg";
  };

  environment.persistence."/state" = {
    hideMounts = true;
    users.rg = {
      # files = [
      #   # ".wakatime.bdb"
      # ];
      directories = [
        ".wakatime"
      ];
    };
  };
  hm = { config, ... }: {
    home.file.wakatime-cfg = {
      enable = true;
      # source = lib.file.mkOutOfStoreSymlink config.age.secrets.wakatime-cfg.path;
      source = config.lib.file.mkOutOfStoreSymlink agePath;
      target = ".wakatime.cfg";
    };
    home.file.wakatime-dbd = {
      enable = true;
      # source = lib.file.mkOutOfStoreSymlink config.age.secrets.wakatime-cfg.path;
      source = config.lib.file.mkOutOfStoreSymlink "/state/home/rg/.wakatime.bdb";
      target = ".wakatime.bdb";
    };
    home.packages = [
      pkgs.wakatime
      (pkgs.writeScriptBin "wakatime" ''
        #!${pkgs.stdenv.shell}
        exec ${pkgs.wakatime}/bin/wakatime-cli $@
      '')
    ];
  };

  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-wakatime
  ];

  programs.fish.plugins = with pkgs.fishPlugins; [
    { name = "wakatime-fish"; inherit (wakatime-fish) src; }
  ];
}
