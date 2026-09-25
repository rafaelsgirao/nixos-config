{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.rg.wifi-initrd;

  confPath = "/etc/wpa_supplicant.conf";
  secretsPath = "/etc/wpa_supplicant/secrets";

  deviceUnit = "sys-subsystem-net-devices-${utils.escapeSystemdPath cfg.interface}.device";

  mkNetwork = ssid: psk: ''
    network={
      ssid="${ssid}"
      key_mgmt=${lib.concatStringsSep " " cfg.authProtocols}
      psk=${psk}
    }
  '';

  supplicantConf = pkgs.writeText "wpa_supplicant-initrd.conf" (
    lib.concatStringsSep "\n" (
      [
        "pmf=1"
        "ext_password_backend=file:${secretsPath}"
      ]
      ++ lib.mapAttrsToList mkNetwork cfg.networks
    )
  );
in
{
  # Wi-Fi inside systemd stage 1, so a host with no wired NIC is still reachable
  # for the ZFS unlock prompt (zfs-unlock-initrd.nix) and can carry the initrd
  # tailscale node (tailscale-initrd.nix).
  #
  # wpa_supplicant only associates; addressing stays with the stage-1
  # systemd-networkd, so the host also needs a
  # boot.initrd.systemd.network.networks entry matching `interface`.
  #
  # The PSK rides in via boot.initrd.secrets, like the initrd ssh host key:
  # appended to the initrd at bootloader install, never copied to the nix store
  # — but it does sit on the unencrypted ESP.
  #
  # Setup (once), alongside the initrd ssh host key:
  #   echo -n 'psk_home=<64 hex chars>' > /pst/etc/ssh-initrd/wifi-psk

  options.rg.wifi-initrd = {
    enable = lib.mkEnableOption "wpa_supplicant in systemd stage 1";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "wlan0";
      description = "Interface wpa_supplicant binds to in stage 1.";
    };

    kernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "rtw88_8822ce" ];
      description = ''
        Wi-Fi driver to force-load in stage 1. Its firmware follows
        automatically: makeModulesClosure pulls every file the modules in the
        closure declare through modinfo, which covers the driver blob and
        cfg80211's regulatory.db.
      '';
    };

    cryptoModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ccm"
        "ctr"
        "aes"
        "aesni_intel"
        "cmac"
        "gcm"
      ];
      description = ''
        Ciphers mac80211 needs to install the pairwise key. None of these are
        built in and none are in the default initrd module set, so without them
        association succeeds and the key install fails with "key addition
        failed" / "Failed to set PTK to the driver". ccm+ctr+aes cover CCMP,
        cmac covers BIP (pmf), gcm covers GCMP.
      '';
    };

    networks = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        Pingu = "ext:psk_home";
      };
      description = ''
        SSID -> psk, in wpa_supplicant.conf syntax: a raw 64-hex PSK, or
        `ext:<name>` naming an entry in `secretsFile`.
      '';
    };

    authProtocols = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "WPA-PSK"
        "WPA-PSK-SHA256"
        "SAE"
      ];
      description = "key_mgmt values offered for every network.";
    };

    secretsFile = lib.mkOption {
      type = lib.types.str;
      default = "/pst/etc/ssh-initrd/wifi-psk";
      description = "Path (on the host, at bootloader-install time) to the `name=value` file backing the `ext:` references above.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Puts regulatory.db in hardware.firmware, which is what modules-closure
    # scans; without it cfg80211 falls back to world-roaming channels.
    hardware.wirelessRegulatoryDatabase = true;

    boot.initrd = {
      kernelModules = cfg.kernelModules ++ cfg.cryptoModules;

      secrets.${secretsPath} = cfg.secretsFile;

      systemd.storePaths = [ "${pkgs.wpa_supplicant}/bin/wpa_supplicant" ];
      systemd.contents.${confPath}.source = supplicantConf;

      systemd.services.wpa_supplicant = {
        description = "WPA Supplicant (stage 1)";
        wantedBy = [ "initrd.target" ];
        requires = [ deviceUnit ];
        after = [ deviceUnit ];
        # The driver can take a couple of tries to come up; no rate limit, or
        # systemd gives up before the radio is ready.
        unitConfig.StartLimitIntervalSec = 0;
        serviceConfig = {
          ExecStart = "${pkgs.wpa_supplicant}/bin/wpa_supplicant -c ${confPath} -i ${cfg.interface}";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
  };
}
