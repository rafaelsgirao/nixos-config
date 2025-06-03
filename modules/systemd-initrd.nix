{ config, pkgs, ... }:
{
  # https://discourse.nixos.org/t/display-contact-info-in-nixos-boot-stage-1/38118/4

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.packages = [ pkgs.toybox ];
  boot.initrd.systemd.contents = {
    "/etc/machine-id".text = config.rg.machineId;
  };
  boot.initrd.systemd.services.contactinfo = {
    wantedBy = [
      # "zfs.target"
      "initrd.target"
    ];
    after = [
      # "zfs-import-rpool.service"
    ];
    before = [ "sysroot.mount" ];
    # path = with pkgs; [
    # ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.TTYPath = "/dev/console";
    serviceConfig.StandardOutput = "tty";
    serviceConfig.Type = "oneshot";
    script = ''
      echo " "
      echo " "
      echo "                                  Rafael Girão"
      echo "                                  E-mail: ${config.networking.hostName}@rafael.ovh"
      echo "                                  E-mail 2: rafael.s.girao@tecnico.ulisboa.pt"
      echo ""
      echo ""
    '';
  };
}
