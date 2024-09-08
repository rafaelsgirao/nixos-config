{ ... }:

{
  imports = [
    ../../modules/cluster/default.nix
  ];

  rg = {
    machineId = "b0540a853280ce070a7279df66918088";
    ip = "192.168.122.61";
    ipv4 = "192.168.122.41";
    # ipv6 = "2a01:4f8:1c1e:aead::1";
    pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9gdgB5xSKVwTG4fAw4nIBV+HxY4pGOxbE/ciNyzMZW";
  };


}
