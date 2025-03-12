{
  config,
  hostSecretsDir,
  pkgs,
  ...
}:

let
  inherit (config.rg) domain;
  siteDir = "/pst/site";
  spyIp = "100.104.162.12";
in
{

  age.secrets.caddy-super-secret-config = {
    file = "${hostSecretsDir}/Caddy-super-secret-config.age";
    mode = "400";
    owner = "caddy";
  };

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
  services.caddy.extraConfig = ''
    import ${config.age.secrets.caddy-super-secret-config.path}
  '';

  services.caddy.virtualHosts = {
    "media.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${spyIp}:8096
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
            # Common
            path /apps/theming/img/*
            path *.js *.css *.ico *.svg

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

        }
        handle @shared {
         reverse_proxy http://${spyIp}:5050
        }

        redir https://${domain}
      '';
    };
    "cache.${domain}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        reverse_proxy http://${spyIp}:33763
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
            handle_errors {
                root * ${pkgs.mypkgs.http-cat}
            	rewrite * /{err.status_code}.jpg
            	file_server
            }
      '';
    };
    "http://idstest.${domain}" = {
      extraConfig = ''
        encode zstd gzip
        respond "uid=0(root) gid=0(root) groups=0(root)"
      '';
    };
    "http://ola-pagarim.${domain}" = {
      extraConfig = ''
        encode zstd gzip
        respond "uid=0(root) gid=0(root) groups=0(root)"
      '';
    };
  };
}
