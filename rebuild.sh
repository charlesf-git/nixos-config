#!/usr/bin/env bash
set -e

FLAKE_DIR="$HOME/nixos-config"
HOSTNAME=$(nix-instantiate --eval -E "(import $FLAKE_DIR/settings.nix).hostname" | tr -d '"')

echo ">> Rebuilding NixOS config for: $HOSTNAME"

nix-shell -p git --run \
  "sudo nixos-rebuild switch --flake $FLAKE_DIR#$HOSTNAME"