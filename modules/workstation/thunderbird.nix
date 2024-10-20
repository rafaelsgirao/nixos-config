{ pkgs, ... }:
{

  environment.persistence."/pst".users.rg.directories = [ ".thunderbird" ];

  hm.programs.thunderbird = {
    enable = true;
    # package = null;
    profiles."rg" = {
      isDefault = true;
      settings = { };
    };
    settings = {
      "general.useragent.override" = "";
      "privacy.donottrackheader.enabled" = true;
      "calendar.alarms.showmissed" = false;
    };
  };
  hm.accounts.email.accounts."rafael@rafael.ovh" = {
    userName = "rafael@rafael.ovh";
    address = "rafael@rafael.ovh";
    imap = {
      host = "mail.rafael.ovh";
      port = 44993; # default
      tls.enable = true;
    };
    #This... doesn't work. it just prompts me for the password on launch anyway
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email rafael@rafael.ovh";
    realName = "Rafael Girão";
    signature.text = ''
      Melhores Cumprimentos / Best Regards,
      Rafael Girão
    '';
    smtp = {
      host = "mail.rafael.ovh";
      port = 44465; # default
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
    };
  };
  hm.accounts.email.accounts."rg@rafael.ovh" = {
    primary = true;
    userName = "rg@rafael.ovh";
    address = "rg@rafael.ovh";
    imap = {
      host = "mx.rafael.ovh";
      port = 993; # default
      tls.enable = true;
    };
    #see above passwordCommand comment
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email rafael@rafael.ovh";
    realName = "Rafael Girão";
    signature.text = ''
      Melhores Cumprimentos / Best Regards,
      Rafael Girão
    '';
    smtp = {
      host = "mx.rafael.ovh";
      port = 465; # default
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
    };
  };
  hm.accounts.email.accounts."rafael.s.girao@tecnico.ulisboa.pt" = {
    # primary = true;
    userName = "ist199309";
    address = "rafael.s.girao@tecnico.ulisboa.pt";
    imap = {
      host = "mail.tecnico.ulisboa.pt";
      port = 993; # default
      tls.enable = true;
    };
    #see above passwordCommand comment
    passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup email rafael.s.girao@tecnico.ulisboa.pt";
    realName = "Rafael Girão";
    signature.text = ''
      Melhores Cumprimentos / Best Regards,
      Rafael Girão
    '';
    smtp = {
      host = "mail.tecnico.ulisboa.pt";
      port = 465; # default
      tls.enable = true;
    };
    thunderbird = {
      enable = true;
    };
  };

}
