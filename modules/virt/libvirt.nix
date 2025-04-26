{ config, lib, ... }:
let
  inherit (lib) optional mkIf;
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

  environment.persistence."/state".directories = [ "/var/lib/libvirt" ];

  users.users.rg.extraGroups = optional isWorkstation [ "libvirtd" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
