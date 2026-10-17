{ config, pkgs, ... }:
let
  inherit (config.networking) hostName;
  inherit (config.rg) domain;

  nixos-switch = pkgs.writeShellApplication {
    name = "nixos-switch";
    runtimeInputs = [ pkgs.curl ];
    text = ''
      action="''${1:-switch}"
      case "$action" in
        switch | boot | test | dry-activate) ;;
        *)
          echo "Usage: nixos-switch [switch|boot|test|dry-activate] [store-path]" >&2
          exit 1
          ;;
      esac

      config_store_path="''${2:-$(curl --fail --silent --show-error --url "https://keyval.${domain}/nixos-system-${hostName}")}"

      if [[ ! "$config_store_path" =~ ^/nix/store/[a-z0-9]{32}-nixos-system-${hostName}-[^/]+$ ]]; then
        echo "fetched store path does not match expected format: $config_store_path" >&2
        exit 1
      fi

      echo "$config_store_path"
      nix build --refresh --no-link -- "$config_store_path"

      if [[ "$action" == switch || "$action" == boot ]]; then
        sudo nix-env -p /nix/var/nix/profiles/system --set "$config_store_path"
      fi

      # CPUWeight=idle so activation yields to whatever is running in the foreground (games on jovian).
      sudo systemd-run \
        -E LOCALE_ARCHIVE \
        -E NIXOS_INSTALL_BOOTLOADER= \
        -p CPUWeight=idle \
        -p IOWeight=1 \
        --collect \
        --no-ask-password \
        --pipe \
        --quiet \
        --service-type=exec \
        --unit=nixos-rebuild-switch-to-configuration \
        --wait \
        "$config_store_path/bin/switch-to-configuration" \
        "$action"
    '';
  };
in
{
  environment.systemPackages = [ nixos-switch ];
}
