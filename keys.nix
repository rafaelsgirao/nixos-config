_:
let
  inherit (builtins) listToAttrs attrNames;

  # Functions defined in this scope are from
  #   https://github.com/hsjobeki/nixpkgs/blob/migrate-doc-comments/lib/attrsets.nix#L1079:C3 , because we don't have lib here.
  mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (attrNames attrs);
  mapAttrs' = f: set: listToAttrs (map (attr: f attr set.${attr}) (attrNames set));
  nameValuePair = name: value: { inherit name value; };
in
rec {
  categories = {
    workstations = {
      inherit (systems) vin adolin;
    };

    servers = {
      inherit (systems) spy saxton adolin;
    };

    knownHosts = {
      "borg.rnl.tecnico.ulisboa.pt" =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLCDWGT0Uv6Q2fgTTtLMDM3nTyeV5mGCIiH6zx+KI2b";
      "git.rnl.tecnico.ulisboa.pt" =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGaP0hqVNDA7CPiPC4zd75JKaNpR2kefJ7qmVEiPtCK";
      "github.com" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRd";
      "lab*p*.rnl.tecnico.ulisboa.pt" =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5pvNnQKZ0/a5CA25a/WVi8oqSgG2q2WKfInNP4xEpP";
      "eu.nixbuild.net" =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      "repo.dsi.tecnico.ulisboa.pt" =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAwJLvpcT0ZAZXzxFgvNPr8uwAg4EEAH2eSvPoeL+jX";
    };
  };

  users = {
    # All user's SSH keys. Users may have multiple SSH keys.
    #TODO: filter keys based on type (age recipients, YK U2F ssh keys, etc.)
    # Not all keys are fit for consumption everywhere.
    rg = [
      "age1yubikey1qfwmheguzsuma4n9dq2vknkkh28d4vcnmvrv82gtzd6gf2scnel45wnnz44" # Yubikey age recipient. Not really an SSH key, but oh well
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEwOBxayZyd/zGYyoTRN2rdIQM71nzVT3lISg2pNfrZRAAAABHNzaDo= rg@Yubikey"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID97/zlRwgxhnOyqHcawWjlL9XjbdmrWbYwayj1bG67I rg@vin[jan '25]"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUY2bke6anCBK8UJxucRZHoDOdi8mO/3DVTB1SLVQ/U rg@adolin[aug'25]"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjmT2OgezvMjGgpMUfAX/8LuYzYJeyOMQjFv+e/cofD rg@BW[aug'25]"

    ];
    media = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYiuCHjX9Dmq69WoAn7EfgovnFLv0VhjL7BSTYQcFa7 dtc@apollo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlaWu32ANU+sWFcwKrPlqD/oW3lC3/hrA1Z3+ubuh5A dtc@bacchus"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmAw3MrBc3MERcNBkerJwfh9fmfD1OCeYnLVJVxs2Rs dtc@xiaomi11tpro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5lKQD5jhYAT7hOLLV/3nD6IJ6BG/2OKIl/Ry5lRDg ft@geoff"
    ];

  };

  # SSH Key of each system's SSH server. Each system has one and only one key.
  systems = {
    vin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRXa7/kHjUK8do4degCAvq1Ak2k3BGIn1kLYtjbQsjk root@vin";
    adolin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9um3nGRV+p323SDncGx9kxMOyU556EBwcKkN3qQF/r root@adolin";

    spy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINC8PlErcHHqvX6xT0Kk9yjDPqZ3kzlmUznn+6kdLxjD root@spy";
    saxton = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIgLXN8cCbZ19eQtmtRsn1R1JEF0gg9lLYWajB2VeE6 root@saxton";
    hoid = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMB0oR/J+r4+k5QVHrIDNqJvM4RARzGd+lQtcxhMfL5w root@hoid";

  };

  # Useful functions.
  flattenKeys = attrs: mapAttrsToList (_name: value: value) attrs;
  toKnownHosts = attrs: mapAttrs' (name: value: nameValuePair name { publicKey = value; }) attrs;
}
