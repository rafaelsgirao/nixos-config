{ config, lib, nixosConfigurations, ... }:

let
  inherit (lib) mapAttrs mapAttrs' nameValuePair;
in

{

  #SSH Server.
  services.openssh = {
    enable = true;
    #Users shouldn't be able to add SSH keys outside this configuration
    authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    settings = {
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      UseDns = false;
      # unbind gnupg sockets if they exists

      PermitRootLogin = "no";
    };
    hostKeys = [
      {
        path = "/pst/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
        rounds = 100;
      }
    ];
  };

  #SSH Client.
  programs.ssh.knownHosts =
    let
      allHostsByName = mapAttrs' (_: host: nameValuePair host.config.networking.hostName host.config.rg.pubKey) nixosConfigurations;
      allHostsByIP = mapAttrs' (_: host: nameValuePair host.config.rg.ip host.config.rg.pubKey) nixosConfigurations;
      myKnownHosts = mapAttrs (_: publicKey: { inherit publicKey; }) (allHostsByName // allHostsByIP);

    in
    myKnownHosts // {
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRd";
      "git.rnl.tecnico.ulisboa.pt".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGaP0hqVNDA7CPiPC4zd75JKaNpR2kefJ7qmVEiPtCK";
      "repo.dsi.tecnico.ulisboa.pt".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAwJLvpcT0ZAZXzxFgvNPr8uwAg4EEAH2eSvPoeL+jX";
    };
  networking.hosts =

    let
      # allHosts = mapAttrs' (_: host: nameValuePair host.config.networking.hostName host.config.rg.ip) nixosConfigurations;
      allHosts = mapAttrs' (_: host: nameValuePair host.config.rg.ip host.config.networking.hostName) nixosConfigurations;
      myKnownHosts = mapAttrs (_: hostName: [ hostName ]) allHosts;
    in
    myKnownHosts;

}
