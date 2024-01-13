_:
{
  users.users.root.password = "";

  microvm = {
    # volumes = [{
    #     mountPoint = "/var";
    #     image = "var.img";
    #     size = 256;
    # }];
    shares = [{
      proto = "virtiofs:w";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];
    hypervisor = "cloud-hypervisor";
    socket = "control.socket";

  };
}
