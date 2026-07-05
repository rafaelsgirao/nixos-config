{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rg.tailscale-initrd;
  ts = config.services.tailscale;
in
{
  # Tailscale inside systemd stage 1, so the ZFS unlock sshd (port 2222) is
  # reachable from anywhere on the tailnet — not just the LAN.
  #
  # Recycled from https://github.com/ElvishJerricco/stage1-tpm-tailscale
  # (initrd-tailscale.nix), except: no persisted state. Each boot registers a
  # fresh *ephemeral* node using an OAuth client secret as auth key, and the
  # node garbage-collects itself once stage 2 takes over.
  #
  # Setup (once):
  #  1. Tailnet policy file:
  #       "tagOwners": { "tag:initrd-unlock": ["autogroup:admin"] },
  #       "grants": [ { "src": ["autogroup:member"],
  #                     "dst": ["tag:initrd-unlock"],
  #                     "ip":  ["tcp:2222"] } ]
  #     No grant with tag:initrd-unlock as src => the node can't initiate
  #     connections to anything on the tailnet. Ping works implicitly.
  #  2. Admin console -> Settings -> OAuth clients -> new client with only the
  #     "auth_keys" scope, tag tag:initrd-unlock.
  #  3. On the host, alongside the initrd ssh host key:
  #       echo -n 'tskey-client-XXXX?ephemeral=true&preauthorized=true' \
  #         > /pst/etc/ssh-initrd/tailscale-authkey
  #     OAuth client secrets don't expire (plain pre-auth keys die in <=90d).
  #
  # Like the initrd ssh host key, the auth key is world-readable in the nix
  # store and sits on the unencrypted ESP. Stolen, it only mints nodes tagged
  # tag:initrd-unlock, which the grants above render harmless.

  options.rg.tailscale-initrd = {
    authKeyFile = lib.mkOption {
      type = lib.types.path;
      default = /pst/etc/ssh-initrd/tailscale-authkey;
      description = "OAuth client secret (with ?ephemeral=true&preauthorized=true) baked into the initrd.";
    };
    tag = lib.mkOption {
      type = lib.types.str;
      default = "tag:initrd-unlock";
      description = "Tailnet tag advertised by the initrd node.";
    };
    dnsServers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "9.9.9.9"
        "1.1.1.1"
      ];
      description = "Stage-1 DNS servers. The main system's resolver (e.g. 127.0.0.1) doesn't exist here.";
    };
  };

  config = {
    boot.initrd = {
      availableKernelModules = [
        "tun"
        "nft_chain_nat"
      ];

      # Reuse the tailscaled.service unit shipped by the tailscale package,
      # configured through the same env vars its /etc/default/tailscaled uses.
      systemd.packages = [ ts.package ];
      systemd.initrdBin = [
        pkgs.iptables
        pkgs.iproute2
        ts.package
      ];

      systemd.services.tailscaled = {
        wantedBy = [ "initrd.target" ];
        serviceConfig.Environment = [
          "PORT=${toString ts.port}"
          ''"FLAGS=--tun ${lib.escapeShellArg ts.interfaceName}"''
        ];
      };

      systemd.services.tailscale-up = {
        wantedBy = [ "initrd.target" ];
        after = [
          "tailscaled.service"
          "systemd-networkd.service"
        ];
        requires = [ "tailscaled.service" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        # Loop instead of ordering after network-online: link may take a
        # moment, and a failed `up` must not block the unlock prompt path.
        script = ''
          for i in $(seq 1 60); do
            if tailscale up \
              --auth-key 'file:/etc/tailscale/authkey' \
              --advertise-tags ${lib.escapeShellArg cfg.tag} \
              --netfilter-mode=off \
              --accept-dns=false \
              --accept-routes=false; then
              exit 0
            fi
            sleep 2
          done
          echo "tailscale up: giving up; LAN ssh unlock still available" >&2
          exit 1
        '';
      };

      systemd.contents = {
        "/etc/tailscale/authkey".source = cfg.authKeyFile;

        # Node name on the tailnet (tailscaled uses the OS hostname).
        "/etc/hostname".text = "${config.networking.hostName}-initrd";

        # tailscaled expects /var/run.
        "/etc/tmpfiles.d/50-tailscale.conf".text = ''
          L /var/run - - - - /run
        '';

        # TLS to the coordination server.
        "/etc/ssl/certs/ca-certificates.crt".source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

        "/etc/systemd/resolved.conf".text = ''
          [Resolve]
          DNS=${lib.concatStringsSep " " cfg.dnsServers}
        '';
      };

      # Let tailscaled manage its own interface.
      systemd.network.networks."50-tailscale" = {
        matchConfig.Name = ts.interfaceName;
        linkConfig = {
          Unmanaged = true;
          ActivationPolicy = "manual";
        };
      };

      systemd.extraBin.ping = "${pkgs.iputils}/bin/ping";

      # systemd-resolved in stage 1, for resolving the coordination server.
      systemd.additionalUpstreamUnits = [ "systemd-resolved.service" ];
      systemd.users.systemd-resolve = { };
      systemd.groups.systemd-resolve = { };
      systemd.storePaths = [
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-resolved"
      ];
      systemd.services.systemd-resolved = {
        wantedBy = [ "initrd.target" ];
        serviceConfig.ExecStartPre = "-+/bin/ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf";
      };
    };
  };
}
