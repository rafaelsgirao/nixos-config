{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rg.netconsole;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.rg.netconsole = {
    enable = mkEnableOption "shipping kernel messages to a host on the same L2 segment";

    target = mkOption {
      type = types.str;
      example = "192.168.1.147";
      description = ''
        Receiver address. netpoll does no routing, so this must be on-link.
        Give the receiver a DHCP reservation: the address is baked into the
        target at activation and a lease change silently stops delivery.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 6666;
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "netconsole" ];

    # netconsole is a console, so console_loglevel gates what reaches it; the
    # default of 4 holds back everything below a warning.
    boot.kernel.sysctl."kernel.printk" = "8 4 1 7";

    systemd.services.netconsole = {
      description = "Ship kernel messages to ${cfg.target}:${toString cfg.port}";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      # Re-runs so a receiver whose MAC rotates (macOS private Wi-Fi addresses
      # do) is picked up without hand-editing the target.
      startAt = "*:0/10";

      path = with pkgs; [
        iproute2
        iputils
        kmod
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        set -eu
        modprobe netconsole 2>/dev/null || true

        target=${lib.escapeShellArg cfg.target}
        dir=/sys/kernel/config/netconsole/main

        route=$(ip -o route get "$target")
        case "$route" in
          *" via "*)
            echo "$target is not on-link; netpoll cannot reach it" >&2
            exit 1
            ;;
        esac
        iface=$(printf '%s' "$route" | sed -n 's/.* dev \([^ ]*\).*/\1/p')
        src=$(printf '%s' "$route" | sed -n 's/.* src \([^ ]*\).*/\1/p')

        # netpoll pins a destination MAC and never ARPs again, so resolve it
        # from the neighbour table rather than trusting a configured value.
        ping -c1 -W2 "$target" >/dev/null 2>&1 || true
        mac=$(ip neigh show "$target" dev "$iface" | sed -n 's/.*lladdr \([^ ]*\).*/\1/p' | head -1)
        # A receiver that is asleep or off the LAN is the normal case; failing
        # here would have systemd retry every 30s, tearing the target down and
        # rebuilding it each time. The timer retries instead.
        if [ -z "$mac" ]; then
          echo "$target did not answer ARP; leaving the current target alone"
          exit 0
        fi

        if [ -d "$dir" ]; then
          if [ "$(cat "$dir/remote_ip")" = "$target" ] \
            && [ "$(cat "$dir/remote_mac")" = "$mac" ] \
            && [ "$(cat "$dir/enabled")" = 1 ]; then
            exit 0
          fi
          echo 0 >"$dir/enabled" 2>/dev/null || true
          rmdir "$dir"
        fi

        mkdir "$dir"
        echo "$src" >"$dir/local_ip"
        echo "$iface" >"$dir/dev_name"
        echo "$target" >"$dir/remote_ip"
        echo "$mac" >"$dir/remote_mac"
        echo ${toString cfg.port} >"$dir/remote_port"
        echo 1 >"$dir/enabled"

        echo "netconsole armed: $iface $src -> $target/$mac:${toString cfg.port}" >/dev/kmsg
      '';
    };
  };
}
