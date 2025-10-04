{ config, ... }:

let

  isWorkstation = config.rg.class == "workstation";
in
{
  age.secrets = {

    ssh-config = lib.mkIf isWorkstation {
      file = "${secretsDir}/SSH-config.age";
      owner = "rg";
    };
    attic-builder-config = lib.mkIf isBuilder {
      file = "${secretsDir}/attic-config-builder.age";
      mode = "400";
      owner = "rg";
    };
  };

  environment.systemPackages = lib.mkIf isBuilder (
    with pkgs;
    [
      attic-client
    ]
  );

  environment.persistence."/pst".users.rg.directories = lib.optionals isWorkstation [
    ".ssh"
    ".local/share/atuin"
    ".local/share/keyrings"
    ".local/share/zoxide"
    ".local/share/direnv"
    ".local/share/nix"
  ];

  environment.persistence."/state".users.rg.directories = lib.optionals (!isWorkstation) [
    ".local/share/atuin"
    ".local/share/zoxide"
  ];
}
