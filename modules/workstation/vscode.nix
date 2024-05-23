{ config, lib, pkgs, ... }:
let
  isGnome = config.services.xserver.desktopManager.gnome.enable;
  inherit (lib) mkIf;
in
{
  hm.programs.vscode =
    let
      p = pkgs.unstable;
    in
    {
      enable = true;
      package = p.vscode;

      #extensions = with p.vscode-extensions;
      #  [
      #    #Jupyter
      #    ms-toolsai.jupyter
      #    ms-toolsai.vscode-jupyter-cell-tags
      #    ms-toolsai.jupyter-renderers
      #    ms-toolsai.jupyter-keymap
      #    # ms-vscode.cpptools
      #    llvm-vs-code-extensions.vscode-clangd
      #    ms-vscode.makefile-tools
      #    matklad.rust-analyzer
      #    eamodio.gitlens
      #    wakatime.vscode-wakatime

      #    bbenoist.nix #  Nix lang support
      #    # ms-python.vscode-pylance
      #    ms-python.python
      #    bradlc.vscode-tailwindcss
      #    # ms-vsliveshare.vsliveshare
      #    usernamehw.errorlens
      #    catppuccin.catppuccin-vsc
      #    ritwickdey.liveserver

      #    nvarner.typst-lsp
      #    mgt19937.typst-preview
      #    mkhl.direnv

      #    # ];
      #  ] ++ p.vscode-utils.extensionsFromVscodeMarketplace [{
      #    name = "vscode-pdf";
      #    publisher = "mathematic";
      #    version = "0.0.6";
      #    sha256 = "sha256-I4y1tzktH4wvD+g4CPeVpqA0S2ZgQ7KyDy6k2Ao4HKU=";
      #  }] ++ p.vscode-utils.extensionsFromVscodeMarketplace [{
      #    name = "ruff";
      #    publisher = "charliermarsh";
      #    version = "2023.12.0";
      #    sha256 = "sha256-si1957iq3Wx5WawJ5JqtgpENE+RcdA279fOQ00XjAjk=";

      #  }] ++ p.vscode-utils.extensionsFromVscodeMarketplace [{
      #    name = "codetogether";
      #    publisher = "genuitecllc";
      #    version = "2023.1.1";
      #    sha256 = "sha256-9XcnsrC3wUo721ldBwT2ZAHaslwHqN1i4tkSbt3OV2I=";
      #  }];
      #};

    }
