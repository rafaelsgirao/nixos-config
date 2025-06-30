_: {

  # Steam needs 32-bit libs - let machines with Steam handle them.
  boot.binfmt.emulatedSystems = [
    "i686-linux"
  ];

  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
  };

  hardware.bluetooth.input = {
    General = {
      ClassicBondedOnly = false;
      UserspaceHID = false;

    };
  };

  programs.gamemode.enable = true;

  users.users.rg.extraGroups = [
    "gamemode"
    "dialout" # Don't really remember what this was for...
  ];

  environment.persistence."/state".users.rg.directories = [
    ".local/share/Steam"
  ];

  services.udev.extraRules = ''
    # DualShock 3 over USB
    KERNEL=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0666"

    # DualShock 3 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:0268*", MODE="0666"

    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';
}
