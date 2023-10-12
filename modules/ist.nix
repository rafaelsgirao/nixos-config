{ pkgs, ... }: {
  # programs.java = {
  #   enable = true;
  #   package = pkgs.zulu;
  # };
  environment.systemPackages = with pkgs; [ krb5 ];
}
