{ lib, ... }:
# let
#   # See original file for detailed option explanations.
#   themeConf = pkgs.writeText "theme.conf" ''
#     # Ursa Major rEFInd theme
#     hideui singleuser,hints,arrows,badges
#
#     icons_dir themes/ursamajor-rEFInd/icons
#
#     banner themes/ursamajor-rEFInd/background.png
#
#     banner_scale fillscreen
#
#     selection_big   themes/ursamajor-rEFInd/selection_big.png
#     selection_small themes/ursamajor-rEFInd/selection_small.png
#
#     showtools shutdown,exit,reboot,firmware
#   '';
#   refindDir = "/boot/EFI/refind";
# in
{
  boot = {
    bootspec.enableValidation = true;
    #EFI variables are a pain.
    #rEFiND is great!
    #TODO: add nixos-install script to automatically install REFIND.
    #while that's not done, install rEFIND manually after nixos-install:
    # nix shell nixpkgs#efibootmgr nixpkgs#refind
    #TODO: hacky way of ensuring REFInd is installed.
    # Figure out a better way
    loader.timeout = 1;
    loader.efi.canTouchEfiVariables = lib.mkDefault false;
    loader.systemd-boot = {
      enable = lib.mkDefault true;
      consoleMode = "auto";
      editor = false;
      configurationLimit = 15;

      #TODO: When https://github.com/nix-community/lanzaboote/issues/375 is closed, extraInstallCommands will work.
      # ${pkgs.refind}/bin/refind-install --usedefault ${config.rg.ESP}
      #   extraInstallCommands = lib.mkIf (config.rg.class == "workstation") ''
      #     ${pkgs.refind}/bin/refind-install
      #     ${pkgs.gnused}/bin/sed -i es/^timeout 5$/timeout 1/' /boot/loader/loader.conf
      #     echo 'auto-entries false' >> /boot/loader/loader.conf
      #     echo 'auto-firmware false' >> /boot/loader/loader.conf
      #   '';
      #   extraInstallCommands = lib.mkIf (config.rg.class == "workstation") ''
      #     echo "Hello world!"
      #     mkdir -p ${refindDir}/themes/ursamajor
      #     cp ${./../../files/refind.conf} ${refindDir}/
      #     cp -R ${pkgs.mypkgs.refind-ursamajor-theme}/. /boot/EFI/refind/themes/ursamajor/
      #     cp ${themeConf} ${refindDir}/ursamajor/theme.conf
      # '';
    };
  };
  #TPM2 support (TPM2 requires UEFI, so leaving the config here)
  # see NixOS Wiki
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  users.users.rg.extraGroups = [ "tss" ];

  hm.home.sessionVariables = {
    TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
    TPM2_PKCS11_TCTI = "device:/dev/tpmrm0";
  };
}
