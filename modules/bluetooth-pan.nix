{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rg.bluetoothPan;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.rg.bluetoothPan = {
    enable = mkEnableOption "dialling a paired phone's Bluetooth NAP as a last-resort uplink";

    deviceFile = mkOption {
      type = types.str;
      example = "/run/agenix/BT-nap-mac";
      description = ''
        File holding the MAC of an already-paired, trusted NAP provider. Read at
        activation rather than baked into the unit, so the address stays out of
        the store. Pairing itself is interactive and lives in /var/lib/bluetooth,
        which bluetooth.nix persists.
      '';
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.powerOnBoot = true;

    systemd.network.networks."13-bnep" = {
      matchConfig.Name = "bnep*";
      DHCP = "yes";
      # Behind eth0 (static) and wlan0 (2048): a ~1-2 Mbps link is a way back
      # in, not a route anything should prefer.
      dhcpV4Config.RouteMetric = 4096;
      linkConfig.RequiredForOnline = "no";
    };

    systemd.services.bluetooth-pan = {
      description = "Bluetooth NAP uplink";
      after = [ "bluetooth.target" ];
      wants = [ "bluetooth.target" ];
      wantedBy = [ "multi-user.target" ];

      # iOS drops the hotspot once nothing is using it, and the phone is not
      # always in range, so this polls rather than dialling once at boot.
      startAt = "*:0/5";

      path = with pkgs; [
        systemd
        iproute2
        coreutils
        gnugrep
      ];

      serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = 90;
      };

      script = ''
        # Secrets are decrypted during activation; an early boot run can lose
        # the race, and the timer will come back around.
        if [ ! -s ${lib.escapeShellArg cfg.deviceFile} ]; then
          echo "no NAP address at ${cfg.deviceFile} yet"
          exit 0
        fi
        mac=$(tr -d '[:space:]' <${lib.escapeShellArg cfg.deviceFile})

        # Interpolated into a D-Bus object path, so reject anything that is not
        # a MAC rather than handing bluez a malformed path.
        if ! printf '%s' "$mac" | grep -qiE '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'; then
          echo "malformed MAC in ${cfg.deviceFile}" >&2
          exit 1
        fi

        obj=/org/bluez/hci0/dev_$(printf '%s' "$mac" | tr ':' '_' | tr '[:lower:]' '[:upper:]')

        # Holding the phone's radio open costs its battery, so only dial when
        # nothing else is carrying a default route.
        if ip -4 route show default | grep -qE 'dev (eth|wlan|en)'; then
          exit 0
        fi

        if busctl get-property org.bluez "$obj" org.bluez.Network1 Connected 2>/dev/null |
          grep -q true; then
          exit 0
        fi

        # An absent phone is the normal case, not a failure worth alerting on.
        if ! busctl call org.bluez "$obj" org.bluez.Network1 Connect s nap; then
          echo "NAP dial failed; will retry"
        fi
      '';
    };
  };
}
