{ lib, ... }: {
  boot = {
    bootspec.enableValidation = true;
    loader.efi.canTouchEfiVariables = lib.mkDefault true;
    loader.systemd-boot = {
      consoleMode = "auto";
      enable = lib.mkDefault true;
      editor = false;
      configurationLimit = 15;
    };
  };
}
