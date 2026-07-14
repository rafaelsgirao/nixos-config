{
  config,
  inputs,
  hostSecretsDir,
  pkgs,
  ...
}:
let
  port = 8791;
  inherit (config.rg) domain;
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

    # ott-rs is validated against its own nixpkgs pin's ffmpeg; 26.05's
    # ffmpeg 8.1.1 fails its finite-HLS remux behavior test.
    ffmpegPackage = inputs.ott-rs.inputs.nixpkgs.legacyPackages.${pkgs.system}.ffmpeg;

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

  services.caddy.virtualHosts."ott.rafael.ovh" = {
    useACMEHost = "${domain}";
    extraConfig = ''
      encode zstd gzip
      reverse_proxy http://127.0.0.1:${toString port}
    '';
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
