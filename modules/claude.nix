# ~/nixos-config/modules/claude.nix
{ config, pkgs, settings, lib, ... }:
let
  developmentDir = "${config.users.users.${settings.username}.home}/Development";

  claude-sandboxed = pkgs.writeShellScriptBin "claude" ''
    # Ensure Development folder exists
    mkdir -p "${developmentDir}"

    # Reject if current directory is outside ~/Development
    case "$PWD" in
      ${developmentDir}*)
        ;;  # allowed
      *)
        echo "Error: claude is sandboxed to ~/Development"
        echo "cd into a project under ~/Development first, or use claude-unsafe for unrestricted access"
        exit 1
        ;;
    esac

    exec ${pkgs.bubblewrap}/bin/bwrap \
      --ro-bind /nix /nix \
      --ro-bind /run /run \
      --ro-bind /etc /etc \
      --ro-bind /bin /bin \
      --ro-bind /lib /lib \
      --ro-bind /lib64 /lib64 \
      --bind "${developmentDir}" "${developmentDir}" \
      --bind "$HOME/.claude" "$HOME/.claude" \
      --ro-bind "$HOME/.config" "$HOME/.config" \
      --ro-bind "$HOME/.nix-profile" "$HOME/.nix-profile" \
      --proc /proc \
      --dev /dev \
      --unshare-pid \
      --die-with-parent \
      --chdir "$PWD" \
      ${pkgs.claude-code}/bin/claude "$@"
  '';

  # Unrestricted escape hatch — use sparingly
  claude-unsafe = pkgs.writeShellScriptBin "claude-unsafe" ''
    echo "Warning: running Claude Code without sandbox restrictions"
    exec ${pkgs.claude-code}/bin/claude "$@"
  '';
in {

  environment.systemPackages = with pkgs; [
    bubblewrap
    claude-sandboxed    # replaces the real `claude` command
    claude-unsafe       # unrestricted escape hatch
  ];

  # Create Development folder declaratively
  home-manager.users.${settings.username}.home.file."Development/.keep".text = "";
}