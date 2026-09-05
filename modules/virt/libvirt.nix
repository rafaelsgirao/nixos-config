{ config, lib, ... }:
let
  inherit (lib) mkIf;
  isWorkstation = config.rg.class == "workstation";
in
{
  #Enable libvirtd
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd = {
    onBoot = mkIf isWorkstation "ignore";
    onShutdown = "shutdown";
    qemu = {
      swtpm.enable = true; # Enables creation of software TPM
      runAsRoot = true;
    };
  };

  environment.persistence."/state" = {
    directories = [ "/var/lib/libvirt" ];
    # systemd host key that decrypts libvirtd's LoadCredentialEncrypted
    # secrets-encryption-key. Must persist alongside /var/lib/libvirt or
    # libvirtd fails at boot with 243/CREDENTIALS after an impermanence wipe.
    files = [ "/var/lib/systemd/credential.secret" ];
  };

  # Also required for management over ssh w/ virt-manager
  users.users.rg.extraGroups = [ "libvirtd" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
