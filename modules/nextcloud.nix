{ config, pkgs, lib, hostSecretsDir, ... }:
let
  # fqdn = config.networking.fqdn;
  ncHost = "cloud.rafael.ovh";
  altHost = "cloud.spy.rafael.ovh";
in
{

  age.secrets = {
    NC-adminpass = {
      file = "${hostSecretsDir}/Nextcloud-adminpass.age";
      owner = "nextcloud";
    };
    # NC-secretfile = {
    #   file = "${hostSecretsDir}/Nextcloud-secretfile.age";
    #   owner = "nextcloud";
    # };
  };
  #Nextcloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    webfinger = true;
    hostName = ncHost;
    configureRedis = true;
    enableImagemagick = false;
    #Makes sure that wherever this module is imported this variable is changed.
    home = lib.mkDefault null;
    # secretFile = config.age.secrets.NC-secretfile.path;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      trustedProxies = [ config.rg.ip "127.0.0.1" "192.168.10.9" ];
      adminpassFile = config.age.secrets.NC-adminpass.path;
      adminuser = "rg";
      overwriteProtocol = "https";
      extraTrustedDomains = [ altHost ];
      defaultPhoneRegion = "PT";
    };
    #Use system's sendmail utility for e-mails
    extraOptions = {
      #Enables imaginary support.
      enabledPreviewProviders = [
        "OC\\Preview\\Imaginary"
        "\\OC\\Preview\\Imaginary"
        "\\OC\\Preview\\Movie"
        "OC\\Preview\\Movie"
      ];
      preview_imaginary_url = "http://${config.services.imaginary.address}:${toString config.services.imaginary.port}";
      mail_smtpmode = "sendmail";
      mail_sendmailmode = "pipe";
      notify_push = {
        enable = true;
        bendDomainToLocalhost = true;
      };
      #Memories options
      memories.vod.ffmpeg = "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg";
      memories.vod.ffprobe = "${pkgs.jellyfin-ffmpeg}/bin/ffprobe";
    };



    # extraApps = with config.services.nextcloud.package.packages.apps; {
    #   inherit calendar contacts deck tasks twofactor_webauthn;
    # };
    # extraAppsEnable = true;
  };

  services.nginx.virtualHosts.${ncHost}.listen = [{
    addr = config.rg.ip;
    port = 5050;
  }];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      # ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES"; - deprecated
      ensureDBOwnership = true;
    }];
  };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/nextcloud/with-postgresql-and-redis.nix
  # https://www.chvp.be/blog/unifiedpush-nextcloud-nixos/
  services.redis.vmOverCommit = true;

  environment.persistence."/state".directories = [
    "/var/lib/redis-nextcloud"
  ];

  systemd.services."phpfpm-nextcloud".serviceConfig = {
    DeviceAllow = [ "/dev/dri/renderD128" ];
    SupplementaryGroups = [ "render" "video" ];
  };
  # For debugging
  # systemd.services."phpfpm-nextcloud".path = with pkgs; [
  environment.systemPackages = with pkgs;[
    redis
    #Adds nodejs 14 to nextcloud's path.
    #Nextcloud marks it as obsolete, but Recognize app only supports v14.
    nodejs

    #Memories app
    exiftool
    jellyfin-ffmpeg
    perl
  ];

  services.imaginary = {
    enable = true;
    settings.return-size = true;
  };

  #TODO: substituir isto pelo plugin do nextcloud do inotify.
  # Se voltar a ativar isto, dar fix à env var HC_NEXTCLOUD_SCAN que atm não existe.
  #inotify plugin não serve actually - é só para external storage
  # systemd.services."nextcloud-file-scan-rg" = {
  #   serviceConfig.Type = "oneshot";
  #   script =
  #     "/run/current-system/sw/bin/nextcloud-occ files:scan rg && ${pkgs.curl}/bin/curl -m 10 --retry 5 $HC_NEXTCLOUD_SCAN";
  # };

  # systemd.timers."nextcloud-file-scan-rg" = {
  #   wantedBy = [ "timers.target" ];
  #   partOf = [ "nextcloud-file-scan-rg.service" ];
  #   timerConfig = {
  #     OnBootSec = "1d";
  #     OnUnitInactiveSec =
  #       "1d"; # Scanning seems to take ~45min, so run this less frequently
  #   };
  # };

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  users.groups.go-vod = { };
  users.users = {
    go-vod = {
      group = "go-vod";
      isSystemUser = true;
      extraGroups = [ "render" "video" ];
    };
  };

  systemd.services."go-vod" =
    let
      pkg = pkgs.jellyfin-ffmpeg;
      goVodConfig = {
        NVENC = true;
        NVENCTemporalAQ = true;
        NVENCScale = "cuda";
        FFmpeg = "${pkg}/bin/ffmpeg";
        FFprobe = "${pkg}/bin/ffprobe";
      };
      GoVodConfigFile = pkgs.writeText "go-vod-config.json" (builtins.toJSON goVodConfig);
    in
    {
      after = [ "network.target" ];
      wantedBy = [ "network.target" ];
      # path = with pkgs; [
      #   jellyfin-ffmpeg
      # ];
      serviceConfig = {
        User = "go-vod";
        Group = "go-vod";

        # https://ma.ttias.be/auto-restart-crashed-service-systemd/
        Restart = "on-failure";
        RestartSec = "5s";


        ExecStart = "${pkgs.mypkgs.go-vod}/bin/go-vod ${GoVodConfigFile}";
        # DeviceAllow = [ "/dev/dri/renderD128" "/dev/dri/renderD129" ];
        ReadOnlyPaths = config.services.nextcloud.home;
        SupplementaryGroups = [ "nextcloud" "video" "render" ];
      };
    };

}
