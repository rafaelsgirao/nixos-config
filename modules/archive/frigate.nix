#Bootstrapped from https://github.com/carjorvaz/nixos/blob/d09a4b06ca797ee0a31e0c5dcfdd8b4cccdfe94f/profiles/frigate.nix#L1
# Thanks @carjorvaz

{ config, hostSecretsDir, ... }:
let
  # inherit (config.rg) domain;
  inherit (config.networking) fqdn;
  hostname = "frigate.${fqdn}";
  port = 42273;
in
{
  environment.persistence."/pst".directories = [ "/var/lib/frigate" ];

  age.secrets.Frigate-env = {
    file = "${hostSecretsDir}/ENV-frigate.age";
    owner = "frigate";
    group = "root";
    mode = "400";
  };

  systemd.services.frigate.serviceConfig = {
    SupplementaryGroups = [ "video" "render" ];
    EnvironmentFile = config.age.secrets.Frigate-env.path;
  };

  services.nginx.virtualHosts.${hostname}.listen = [{
    addr = "127.0.0.1";
    inherit port;
  }];

  services.caddy.virtualHosts = {
    "${hostname}" = {
      useACMEHost = "rafael.ovh";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://127.0.0.1:${toString port}
      '';
    };
  };

  services.frigate = {
    enable = true;
    inherit hostname;
    settings = {
      cameras = {
        Cam1 = {
          ffmpeg.inputs = [
            {
              path =
                "rtsp://{FRIGATE_RTSP_USER1}:{FRIGATE_RTSP_PWD1}@192.168.1.175:554/stream1";
              # roles = [ "detect" "record" "audio" ];
              roles = [ "detect" "record" ];

            }
          ];

          detect.enabled = true; # <---- disable detection until you have a working camera feed
          record.enabled = true;
          # audio.enabled = true; #only available in v13, nixpkgs 23.11 has v12
        };

      };

    };
  };

}



# admin
# Comic4.Hatching.Fiber
# cctv-vigi-recovery@rafael.ovh
