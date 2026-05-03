# ~/nixos-config/rebuild.sh
#!/usr/bin/env bash
HOSTNAME=$(nix eval --raw .#nixosConfigurations --apply 'x: builtins.head (builtins.attrNames x)' 2>/dev/null)
sudo nixos-rebuild switch --flake ~/nixos-config#$HOSTNAME