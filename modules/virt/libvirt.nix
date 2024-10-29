_: {
  #Enable libvirtd
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd = {
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      swtpm.enable = true; # Enables creation of software TPM
      runAsRoot = true;
    };
  };

  environment.persistence."/state".directories = [ "/var/lib/libvirt" ];

  users.users.rg.extraGroups = [ "libvirtd" ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
