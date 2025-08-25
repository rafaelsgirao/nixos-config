{
  config,
  hostSecretsDir,
  pkgs,
  ...
}:

let
  inherit (config.rg) domain;
  siteDir = "/pst/site";
  pub = "rafael.ovh";
in
{

  age.secrets.caddy-super-secret-config = {
    file = "${hostSecretsDir}/Caddy-super-secret-config.age";
    mode = "400";
    owner = "caddy";
  };

  environment.etc."flake-registry/flake-registry.json" = {
    inherit (config.environment.etc."nix/registry.json") source;
    mode = "0444";
    user = "caddy";
    group = "caddy";
  };

  # services.caddy.globalConfig = ''
  #   # default_bind ${config.rg.ipv4} [${config.rg.ipv6}]
  # '';

  services.caddy.extraConfig = ''
    import ${config.age.secrets.caddy-super-secret-config.path}
  '';

  services.caddy.virtualHosts = {
    # "cloud.${pub}" = {
    #   useACMEHost = "${domain}";
    #   extraConfig = ''
    #     encode zstd gzip
    #
    #     @shared {
    #         # Common
    #         path /apps/theming/img/*
    #         path *.js *.css *.ico *.svg
    #
    #         # Photos
    #         path /apps/photos/public/*
    #         path /apps/photos/api/v1/publicPreview/
    #         path /remote.php/dav/photospublic/*
    #
    #         # Memories
    #         path /apps/memories/a/*
    #         path /apps/memories/s/*
    #         path /apps/memories/api/* # Would be better if this was more fine-grained
    #
    #         # Cospend
    #         path /apps/cospend/s/*
    #         path /ocs/v2.php/apps/cospend/api/v1/public/*
    #
    #     }
    #     handle @shared {
    #      reverse_proxy http://${spyIp}:5050
    #     }
    #
    #     redir https://${pub}
    #   '';
    # };
    "www.${pub}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        redir https://${domain}{uri}
      '';
    };
    "*.${pub}" = {
      useACMEHost = "${domain}";
      extraConfig = ''
        encode zstd gzip
        redir https://${domain}
      '';
    };
    "${pub}" = {
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
    "http://idstest.${pub}" = {
      extraConfig = ''
        encode zstd gzip
        respond "uid=0(root) gid=0(root) groups=0(root)"
      '';
    };
    "http://ola-pagarim.${pub}" = {
      extraConfig = ''
        encode zstd gzip
        respond "uid=0(root) gid=0(root) groups=0(root)"
      '';
    };
  };
}
