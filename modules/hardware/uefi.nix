{ lib, ... }: {
  boot = {
    bootspec.enableValidation = true;
    #EFI variables are a pain.
    #rEFiND is great!
    #TODO: add nixos-install script to automatically install REFIND.
    #while that's not done, install rEFIND manually after nixos-install:
    # nix shell nixpkgs#efibootmgr nixpkgs#refind
    # sudo refind-install --usedefault /dev/<ESP>
    loader.efi.canTouchEfiVariables = lib.mkDefault false;
    loader.systemd-boot = {
      consoleMode = "auto";
      enable = lib.mkDefault true;
      editor = false;
      configurationLimit = 15;
    };
  };
}
