# Pre-fetch the system closure from the binary cache so that a subsequent
# `nixos-rebuild switch` has everything already in the local nix store.
#
# Assumes the cache always has the wanted closure. `--max-jobs 0` forbids any
# local building: every path must come from a substituter, or nix errors out.

HOST  ?= $(shell hostname)
CACHE ?= https://cache.rsg.ovh

TOPLEVEL := .\#nixosConfigurations.$(HOST).config.system.build.toplevel

NIX_FLAGS := --no-link \
             --max-jobs 0 \
             --accept-flake-config \
             --substituters $(CACHE)

.DEFAULT_GOAL := pull

.PHONY: pull switch boot

## pull: download this host's system closure from the cache into the local store
pull:
	nix build $(TOPLEVEL) $(NIX_FLAGS)

## switch: pull the closure, then activate it
switch: pull
	sudo nixos-rebuild switch --flake .#$(HOST)

## boot: pull the closure, then set it for next boot
boot: pull
	sudo nixos-rebuild boot --flake .#$(HOST)
