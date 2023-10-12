{ config, hostSecretsDir, ... }:
let
  domain = "rafael.ovh";
  fqdn = "mail.rafael.ovh";
  certDir = config.security.acme.certs.${fqdn}.directory;
  vmailUser = config.mailserver.vmailUserName;

in
{
  security.acme.certs."${fqdn}" = {
    domain = "mail.${domain}";
    extraDomainNames = [ "${domain}" "mx.${domain}" "mail.${domain}" ];
    # group = "maddy";
  };

  environment.persistence."/pst".directories = [
    { directory = config.mailserver.mailDirectory; user = vmailUser; group = vmailUser; }
    # { directory = config.mailserver.dkimKeyDirectory; user = dkimUser; group = dkimUser; }
  ];
  #SNM enables postfix's sendmail utility, which conflicts with msmtp.

  programs.msmtp.enable = false;
  age.secrets = {
    mailserver-pwd-rafael = {
      file = "${hostSecretsDir}/Mailserver-pwd-rafael.age";
    };
    mailserver-pwd-machines = {
      file = "${hostSecretsDir}/Mailserver-pwd-machines.age";
    };
  };
  mailserver = {
    enable = true;
    inherit fqdn;
    domains = [ domain ];
    loginAccounts = {
      "rg@rafael.ovh" = {
        hashedPasswordFile = config.age.secrets.mailserver-pwd-rafael.path;
        aliases = [ "@rafael.ovh" ];
      };
      "machines@rafael.ovh" = {
        hashedPasswordFile = config.age.secrets.mailserver-pwd-machines.path;
        sendOnly = true;
      };
    };
    monitoring = {
      alertAddress = "rafaelgirao+snm-monit@proton.me";
      enable = true;
    };
    certificateScheme = "acme";
    certificateFile = "${certDir}/cert.pem";
    keyFile = "${certDir}/key.pem";
    #Disable STARTTLS
    enableImap = false;
    enableSubmission = false;
    dkimKeyDirectory = "/pst/var/dkim";
  };
  # https://github.com/krathalan/systemd-sandboxing/blob/master/postfix.service.d/hardening.conf
  # https://groups.google.com/g/list.postfix.users/c/doN4fj9t41Q?pli=1
  systemd.services.postfix.serviceConfig = {
    RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6 AF_NETLINK" ];
    IPAccounting = "yes";
    ProtectSystem = "strict";
    ReadWritePaths = [ "-/var/spool/postfix -/var/lib/postfix -/run/opendkim -/run/postgrey" ];
    PrivateTmp = "yes";
    PrivateDevices = "yes";
    ProtectKernelTunables = "yes";
    ProtectKernelModules = "yes";
    ProtectKernelLogs = "yes";
    CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE CAP_KILL CAP_SETUID CAP_SETGID CAP_NET_BIND_SERVICE " ];
    ProtectHostname = "yes";
    ProtectClock = "yes";
    ProtectControlGroups = "yes";
    RestrictNamespaces = "yes";
    LockPersonality = "yes";
    MemoryDenyWriteExecute = "yes";
    RestrictSUIDSGID = "yes";
    RemoveIPC = "yes";
    # SystemCallFilter = [ "@privileged @system-service"  "~@resources" "~@reboot "];
    SystemCallFilter = [ "@system-service @mount" "~ @resources " ];

    SystemCallArchitectures = "native";
    #Mine
    NoNewPrivileges = "yes";

  };
}
