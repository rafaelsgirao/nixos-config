{ config, ... }:

let
  inherit (config.rg) domain;
  siteDir = "/pst/site";
in
{

  #ACME + Caddy
  security.acme.certs."${domain}" = {
    # https://github.com/0xERR0R/blocky/issues/33
    extraLegoRunFlags = [
      "--preferred-chain"
      "ISRG Root X1"
    ];
  };

  environment.etc."flake-registry/flake-registry.json" = {
    inherit (config.environment.etc."nix/registry.json") source;
    mode = "0444";
    user = "caddy";
    group = "caddy";
  };

  services.caddy.globalConfig = ''
    default_bind ${config.rg.ipv4} [${config.rg.ipv6}]
  '';

  services.caddy.virtualHosts = {
    "media.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://192.168.10.6:8096
      '';
    };
    "dns.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        #TODO2: look at dnscrypt-proxy's serviceConfig, harden blocky more with it
        respond /api/* 404
        reverse_proxy http://127.0.0.1:4000
      '';
    };
    "cloud.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip

        @shared {
            # Needed common paths
            path /apps/theming/img/*

            # Photos
            path /apps/photos/public/*
            path /apps/photos/api/v1/publicPreview/
            path /remote.php/dav/photospublic/*

            # Memories
            path /apps/memories/a/*
            path /apps/memories/s/*
            path /apps/memories/api/* # Would be better if this was more fine-grained

            # Cospend
            path /apps/cospend/s/*
            path /ocs/v2.php/apps/cospend/api/v1/public/*

            path *.js *.css *.ico *.svg
        }
        handle @shared {
         reverse_proxy http://192.168.10.6:5050
        }

        redir https://${domain}
      '';
    };
    "cache.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://192.168.10.6:33763
      '';
    };
    "www.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        redir https://${domain}{uri}
      '';
    };
    "*.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        redir https://${domain}
      '';
    };
    "${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
            encode zstd gzip
            respond /evil/.git* 404
           	@isRegistry file {
        		root /etc/flake-registry
        	}
        	handle @isRegistry {
        		root * /etc/flake-registry
        		file_server
        	}
            handle {
                root * ${siteDir}/main
                file_server browse {
                  hide .git
                }
            }
      '';
    };
    "http://idstest.${domain}" = {
      extraConfig = ''
        encode zstd gzip
        respond "uid=0(root) gid=0(root) groups=0(root)"
      '';
    };
    "e.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        root * ${siteDir}/main/html/evil
        respond /.git* 404
        file_server {
          hide .git
        }
      '';
    };
  };
}
