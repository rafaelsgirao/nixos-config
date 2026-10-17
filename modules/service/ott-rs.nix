{
  config,
  inputs,
  hostSecretsDir,
  lib,
  pkgs,
  ...
}:
let
  port = 8791;
  webPort = 8792;
  ottCfg = config.services.ott-rs;
  inherit (config.rg) domain;

  # Upstream's patched FFmpeg comes from ott-rs's own nixpkgs, which the
  # ccache overlay never reaches; rebuild the same patch on host pkgs.
  ffmpeg = pkgs.callPackage "${inputs.ott-rs}/nix/ffmpeg.nix" {
    ffmpeg = pkgs.ffmpeg.override { stdenv = pkgs.ccacheStdenv; };
  };

  # Upstream closes over its own FFmpeg in the wrapper and check inputs.
  ott-rs = inputs.ott-rs.packages.${pkgs.stdenv.hostPlatform.system}.ott-rs.overrideAttrs {
    nativeCheckInputs = [ ffmpeg ];
    # The opt-in real-FFmpeg UHD gates race their own timeouts under razer's
    # aarch64 binfmt emulation.
    checkFlags = [ ];
    postInstall = "wrapProgram $out/bin/ott-rs --suffix PATH : ${lib.getBin ffmpeg}/bin";
  };
in
{
  imports = [ inputs.ott-rs.nixosModules.default ];

  # Bootstrap (once, on the host): the Telegram session must be created
  # interactively before the refresh timer can succeed:
  #   sudo systemctl stop ott-rs.timer
  #   sudo -u ott-rs env $(sudo cat /run/agenix/ENV-ott-rs | xargs) \
  #     ott-rs auth --session-dir /var/lib/ott-rs/telegram
  #   sudo systemctl start ott-rs.timer ott-rs.service
  services.ott-rs = {
    enable = true;

    ffmpegPackage = ffmpeg;
    package = ott-rs;

    # OTT_RS_TG_API_ID, OTT_RS_TG_API_HASH and OTT_RS_TG_CHAT_ID.
    environmentFile = config.age.secrets.ENV-ott-rs.path;

    telegram.enable = true;

    # Keep stream health fresh so serve prefers working streams.
    healthSample.enable = true;

    # Token-gated browser/TV API on loopback; exposed through Caddy below.
    clientApi = {
      enable = true;
      inherit port;
      tokenFile = config.age.secrets.ott-rs-client-token.path;
    };
  };

  # Token-gated API edge for ott-tv and other non-browser clients.
  services.caddy.virtualHosts."ott-api.rafael.ovh" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };

  # Browser UI: OIDC via oauth2-proxy/pocket-id instead of tokens, proxying
  # to a dedicated tokenless serve instance that is only reachable through
  # this authenticated vhost.
  services.caddy.virtualHosts."ott.rafael.ovh" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip

      handle /oauth2/* {
        reverse_proxy http://127.0.0.1:4180
      }
      handle {
        forward_auth http://127.0.0.1:4180 {
          uri /oauth2/auth
          @unauthorized status 401
          handle_response @unauthorized {
            redir * /oauth2/start?rd={scheme}://{host}{uri}
          }
        }
        reverse_proxy http://127.0.0.1:${toString webPort} {
          flush_interval -1
        }
      }
    '';
  };

  # Tokenless serve instance for the OIDC-gated browser vhost. The upstream
  # module's equivalent (web.tailscaleAuth.trustedClientApi) is welded to
  # nginx, so it is mirrored here for Caddy: same artifacts, same hardening
  # as ott-rs-client-api, no --token-file, loopback only.
  systemd.services.ott-rs-web = {
    description = "Serve tokenless ott-rs browser API behind OIDC";
    after = [
      "network-online.target"
      "ott-rs.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = ottCfg.channelSelectionPath;
    path = [ ottCfg.ffmpegPackage ];
    serviceConfig = {
      Type = "simple";
      ExecStart = lib.escapeShellArgs [
        "${ottCfg.package}/bin/ott-rs"
        "serve"
        "--bind"
        "127.0.0.1:${toString webPort}"
        "--channel-selection"
        ottCfg.channelSelectionPath
        "--source-inventory"
        ottCfg.sourceInventoryPath
        "--guide-input"
        ottCfg.guide.artifactPath
        "--health-state"
        ottCfg.health.statePath
      ];
      Restart = "on-failure";
      RestartSec = "10s";
      User = ottCfg.user;
      Group = ottCfg.group;
      ReadOnlyPaths = [ "/var/lib/ott-rs" ];
      StateDirectory = "ott-rs";
      StateDirectoryMode = "0700";
      UMask = "0027";
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      CapabilityBoundingSet = "";
      SystemCallArchitectures = "native";
    };
  };

  age.secrets = {
    ENV-ott-rs = {
      file = "${hostSecretsDir}/ENV-ott-rs.age";
    };
    ott-rs-client-token = {
      file = "${hostSecretsDir}/ott-rs-client-token.age";
      mode = "440";
      owner = config.services.ott-rs.user;
      group = config.services.ott-rs.group;
    };
  };

  # Telegram session, refresh state and health artifacts.
  environment.persistence."/pst".directories = [
    {
      directory = "/var/lib/ott-rs";
      user = config.services.ott-rs.user;
      group = config.services.ott-rs.group;
      mode = "0700";
    }
  ];
}
