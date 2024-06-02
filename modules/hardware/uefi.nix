{ lib, ... }: {
  boot = {
    bootspec.enableValidation = true;
    #EFI variables are a pain.
    #rEFiND is great!
    #TODO: add nixos-install script to automatically install REFIND.
    #while that's not done, install rEFIND manually after nixos-install:
    # nix shell nixpkgs#efibootmgr nixpkgs#refind
    #TODO: hacky way of ensuring REFInd is installed.
    # Figure out a better way 
    loader.efi.canTouchEfiVariables = lib.mkDefault false;
    loader.systemd-boot = {
      enable = lib.mkDefault true;
      consoleMode = "auto";
      editor = false;
      configurationLimit = 15;
      # ${pkgs.refind}/bin/refind-install --usedefault ${config.rg.ESP}
      # extraInstallCommands = lib.mkIf (config.rg.class == "workstation") ''
      #   ${pkgs.refind}/bin/refind-install
      #   ${pkgs.gnused}/bin/sed -i es/^timeout 5$/timeout 1/' /boot/loader/loader.conf
      #   echo 'auto-entries false' >> /boot/loader/loader.conf
      #   echo 'auto-firmware false' >> /boot/loader/loader.conf
      # '';
    };
  };
}
