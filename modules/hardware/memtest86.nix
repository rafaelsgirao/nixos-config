{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.boot) lanzaboote;
  esp = config.boot.loader.efi.efiSysMountPoint;
  espDir = "efi/memtest86";
  espPath = "${espDir}/memtest.efi";

  entry = pkgs.writeText "memtest86.conf" ''
    title  Memtest86+
    efi    /${espPath}
    sort-key o_memtest86
  '';
in
{
  # Memtest86+ as a boot menu entry.
  #
  # On plain systemd-boot the upstream option does everything. Under lanzaboote
  # the systemd-boot module is disabled (mkForce false), so its extraFiles /
  # extraEntries are never installed, and lzbt only ever writes the NixOS
  # generations to the ESP. Hence the unit below, which drops the same two files
  # there — signing the binary with the Secure Boot keys, or the firmware would
  # refuse to launch it once Secure Boot is on.
  boot.loader.systemd-boot.memtest86.enable = !lanzaboote.enable;

  systemd.services.memtest86-esp = lib.mkIf lanzaboote.enable {
    description = "Install Memtest86+ on the ESP";
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = esp;

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      mkdir -p ${esp}/${espDir} ${esp}/loader/entries
      ${lib.getExe' pkgs.sbsigntool "sbsign"} \
        --key ${lanzaboote.privateKeyFile} \
        --cert ${lanzaboote.publicKeyFile} \
        --output ${esp}/${espPath} \
        ${pkgs.memtest86plus.efi}
      cp ${entry} ${esp}/loader/entries/memtest86.conf
    '';
  };
}
