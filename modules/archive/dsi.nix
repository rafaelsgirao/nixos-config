{ pkgs, ... }:
{
  # programs.java = {
  #   enable = true;
  #   package = pkgs.zulu;
  # };
  environment.systemPackages = with pkgs; [
    glab
    krb5
    mypkgs.chef-workstation
    mypkgs.setupSecrets
    vault
  ];

  #--------------------------------------------
  #--------------Kerberos Settings-------------
  #--------------------------------------------

  # krb5 = {
  #   enable = true;
  #   libdefaults = {
  #     default_realm = "IST.UTL.PT";
  #     kdc_timesync = 1;
  #     ccache_type = 4;
  #     forwardable = true;
  #     proxiable = true;
  #   };
  #   domain_realm = {
  #     "ist.utl.pt" = "IST.UTL.PT";
  #     ".ist.utl.pt" = "IST.UTL.PT";
  #   };
  #   realms = {
  #     "IST.UTL.PT" = {
  #       admin_server = "kerberosmaster.ist.utl.pt";
  #       #    kdc = [
  #       #      "athena01.mit.edu"
  #       #      "athena02.mit.edu"
  #       #    ];
  #     };
  #   };
  # };

}
