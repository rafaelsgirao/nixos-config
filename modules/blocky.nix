{ config, lib, pkgs, ... }:
let
  cfg = config.services.blocky;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
in
{
  environment.systemPackages = [ pkgs.blocky ];
  systemd.services.blocky = {
    after = [ "network-online.target" ];
    wantedBy = [ "network-online.target" ];
    serviceConfig = {
      ExecStart =
        lib.mkForce "${pkgs.blocky}/bin/blocky --config ${configFile}";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 15";
    };
    # after= [ "network-online.target "];
    wants = [ "network-online.target" "systemd-networkd-wait-online.service" ];
  };
  systemd.services."blocky".serviceConfig = {
    MemoryDenyWriteExecute = true;
    ProtectKernelLogs = true;
    LockPersonality = true;
    ProtectClock = true;
    ProtectKernelModules = true;
    ProtectHome = true;
    ProtectHostname = true;
    PrivateUsers = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    ProtectControlGroups = true;
    ProtectKernelTunables = true;
    PrivateDevices = true;
    ProtectSystem = "strict";
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
  };
  services.blocky.enable = true;
  services.blocky.settings = {
    # https://github.com/oneoffdallas/dohservers/blob/master/list.txt
    upstream.default = [
      # "https://one.one.one.one/dns-query"
      "https://dns-unfiltered.adguard.com/dns-query"
      "https://dns.quad9.net/dns-query"
      "https://cloudflare-dns.com/dns-query"
      "https://doh.applied-privacy.net/query"
      "https://unicast.uncensoreddns.org/dns-query"
      # "https://doh.libredns.gr/dns-query" # Doesn't support DNSSEC https://gitlab.com/libreops/libredns/libredns-cfg/-/issues/3
    ];
    startVerifyUpstream = false;
    upstreamTimeout = "12s";

    customDNS = {
      customTTL = "24h";
      filterUnmappedTypes = true;
      mapping = {
        "scout" = "192.168.10.1";
        "scout.rafael.ovh" = "192.168.10.1";

        # Discontinued
        # "heavy" = "192.168.10.2";
        # "heavy.rafael.ovh" = "192.168.10.2";

        "engineer" = "192.168.10.3";
        "engie" = "192.168.10.3";
        "engie.rafael.ovh" = "192.168.10.3";
        "mail.rafael.ovh" = lib.mkIf (config.networking.hostName != "engie")
          (lib.mkDefault "192.168.10.3");

        # Discontinued
        # "pyro" = "192.168.10.4";
        # "pyro.rafael.ovh" = "192.168.10.4";

        "medic" = "192.168.10.5";
        "medic.rafael.ovh" = "192.168.10.5";
        "medicist" =
          lib.mkIf (config.networking.hostName != "engie") "193.136.132.93";

        "spy" = "192.168.10.6";
        "spy.rafael.ovh" = "192.168.10.6";
        "media.rafael.ovh" =
          lib.mkIf (config.networking.hostName != "engie") "192.168.10.6";

        "demo" = "192.168.10.7";
        "demo.rafael.ovh" = "192.168.10.7";

        "sniper" = "192.168.10.8";
        "sniper.rafael.ovh" = "192.168.10.8";

        "saxton" = "192.168.10.9";
        "saxton.rafael.ovh" = "192.168.10.9";
      };
    };
    blocking.blackLists = {
      "none" = null;
      "rg" = [ "https://priv.rafael.ovh/rg_domains.txt" ];
      "normal" = [
        "https://hosts.oisd.nl/"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts"
        "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
        "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
        "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&amp;showintro=0&amp;mimetype=plaintext"
        "https://v.firebog.net/hosts/Easylist.txt"
        "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
        "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
        "https://v.firebog.net/hosts/Admiral.txt"
        "https://v.firebog.net/hosts/AdguardDNS.txt"
        "https://adaway.org/hosts.txt"
        "https://v.firebog.net/hosts/static/w3kbl.txt"
        "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
        "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
        "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"
        "https://urlhaus.abuse.ch/downloads/hostfile/"
        "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
        "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
        # "https://v.firebog.net/hosts/Shalla-mal.txt"
        "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
        "https://phishing.army/download/phishing_army_blocklist_extended.txt"
        "https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt"
        "https://v.firebog.net/hosts/Prigent-Crypto.txt" # blocks getmonero.org
        "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"
        # "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt" #blocked freaking media.discordapp.net
        "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
        "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
        "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
        "https://v.firebog.net/hosts/Easyprivacy.txt"
        "https://v.firebog.net/hosts/Prigent-Ads.txt"
        "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
        "https://raw.githubusercontent.com/MajkiIT/polish-ads-filter/master/polish-pihole-filters/NoTrack_Tracker_Blocklist.txt"
        "https://zerodot1.gitlab.io/CoinBlockerLists/hosts" # blocks getmonero.org
        "https://raw.githubusercontent.com/stamparm/aux/master/maltrail-malware-domains.txt"
        "https://malware-filter.gitlab.io/malware-filter/pup-filter.txt"
        #TODO: adicionar custom blocked domains
        #TODO: ver o blocky/config.yaml no engineer e acabar
      ];
    };
    blocking.whiteLists.normal = [
      "|\n        go.foxitinfo.com\n        quantcast.mgr.consensu.org\n        plausible.io\n        cio.improvmx.com\n        t.paypal.com\n        rdvs.alljoyn.org\n        cta-redirect.hubspot.com #bupi.gov.pt precisa\n        /(\\.|^)ipinfo\\.io$/\n        /(\\.|^)getmonero\\.org$/\n        "
    ];
    blocking = {
      clientGroupsBlock = {
        "192.168.10.1" = [ "normal" "rg" ];
        "192.168.10.2" = [ "none" ];
        "192.168.10.3" = [ "none" ];
        "192.168.10.5" = [ "normal" "rg" ];
        "192.168.10.6" = [ "none" ];
        "public" = [ "normal" ];
        # "pt-phishing" = [ "pt-phishing" ];
        "default" = lib.mkDefault [ "normal" ];
      };
      processingConcurrency = 20;
      blockType = "nxDomain";
      blockTTL = "24h";
      refreshPeriod = "12h";
      downloadTimeout = "10s";
      downloadAttempts = 2;
      downloadCooldown = "5s";
      failStartOnListError = false;
    };
    caching = {
      minTime = "2h";
      maxTime = "12h";
      maxItemsCount = 0;
      prefetching = true;
      prefetchExpires = "2h";
      prefetchThreshold = 5;
    };
    prometheus.enable = false;
    port = lib.mkDefault "${config.rg.ip}:53";
    # tlsPort = 853;
    tlsPort = lib.mkDefault null;
    # httpPort = "127.0.0.1:4000";
    httpPort = lib.mkDefault "127.0.0.1:4000"; #Blocky CLI expects port 4000 by default
    # httpPort =
    # lib.mkIf (config.networking.hostName != "scout") (lib.mkDefault 4000);
    minTlsServeVersion = "1.2";
    bootstrapDns = "tcp+udp:1.1.1.1";
    logLevel = "info";
    logFormat = "text";
    logTimestamp = false;
    logPrivacy = lib.mkDefault false;
  };
}
