#!/usr/bin/env bash
#sudo nix run --extra-experimental-features "nix-command flakes" 'github:nix-community/disko' -- --mode disko --flake .#vin # --disk main /dev/sdc
sudo nix run --extra-experimental-features "nix-command flakes" 'github:nix-community/disko' -- --flake .#vin # --disk main /dev/sdc
#sudo nix run --extra-experimental-features 'github:nix-community/disko#disko-install' -- --flake .#vin --disk main /dev/sdc

# or sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disk-config.nix
