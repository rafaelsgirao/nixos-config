{
  config,
  lib,
  nixosConfigurations,
  ...
}:

let
  inherit (lib) mapAttrs mapAttrs' nameValuePair;
in

{

  #SSH Server.
  services.openssh = {
    enable = true;
    openFirewall = false;
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

      PermitRootLogin = lib.mkDefault "no";
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
      allHostsByName = mapAttrs' (
        _: host: nameValuePair host.config.networking.hostName host.config.rg.pubKey
      ) nixosConfigurations;
      allHostsByIP = mapAttrs' (
        _: host: nameValuePair host.config.rg.ip host.config.rg.pubKey
      ) nixosConfigurations;
      myKnownHosts = mapAttrs (_: publicKey: { inherit publicKey; }) (allHostsByName // allHostsByIP);

    in
    myKnownHosts
    // {
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRd";
      "git.rnl.tecnico.ulisboa.pt".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGaP0hqVNDA7CPiPC4zd75JKaNpR2kefJ7qmVEiPtCK";
      "repo.dsi.tecnico.ulisboa.pt".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAwJLvpcT0ZAZXzxFgvNPr8uwAg4EEAH2eSvPoeL+jX";
      "lab*p*.rnl.tecnico.ulisboa.pt".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5pvNnQKZ0/a5CA25a/WVi8oqSgG2q2WKfInNP4xEpP";
      borg = {
        hostNames = [
          "borg"
          "borg.rnl.tecnico.ulisboa.pt"
          "borg.rnl.ist.utl.pt`"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLCDWGT0Uv6Q2fgTTtLMDM3nTyeV5mGCIiH6zx+KI2b";
      };
      nixbuild = {
        hostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };
}
