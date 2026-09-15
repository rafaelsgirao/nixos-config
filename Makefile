# Pre-fetch the system closure from the binary cache so that a subsequent
# `nixos-rebuild switch` has everything already in the local nix store.
#
# Assumes the cache always has the wanted closure. The closure is addressed by
# its output path: asking nix for the flake attr instead resolves the whole
# derivation graph, and the trivial derivations in it (fish completions,
# modules-shrunk) carry allowSubstitutes = false, so nix builds them locally
# no matter what the cache holds.

HOST  ?= $(shell hostname)
CACHE ?= https://cache.rsg.ovh

TOPLEVEL := .\#nixosConfigurations.$(HOST).config.system.build.toplevel

# NIX_FLAGS := --no-link \
#              --max-jobs 0 \
#              --accept-flake-config \
#              --substituters $(CACHE)

EVAL_FLAGS := --raw --accept-flake-config

.DEFAULT_GOAL := pull

.PHONY: pull switch boot

## pull: download this host's system closure from the cache into the local store
pull:
#	nix build $(TOPLEVEL) $(NIX_FLAGS)
	nix copy --from $(CACHE) "$$(nix eval $(EVAL_FLAGS) $(TOPLEVEL))"

## switch: pull the closure, then activate it
switch: pull
	sudo nixos-rebuild switch --flake .#$(HOST)

## boot: pull the closure, then set it for next boot
boot: pull
	sudo nixos-rebuild boot --flake .#$(HOST)
