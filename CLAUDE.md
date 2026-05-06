# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Applying the Configuration

```bash
# Rebuild and switch — derives hostname automatically from settings.nix
~/nixos-config/rebuild.sh
```

This runs `sudo nixos-rebuild switch --flake ~/nixos-config#<hostname> --impure`. The `--impure` flag is required because `flake.nix` imports `settings.nix` at evaluation time.

## Architecture

This is a **flake-based, single-machine, modular NixOS configuration**. The key design principle is that hardware-specific and machine-specific files (`/etc/nixos/hardware-configuration.nix`, `/etc/nixos/configuration.nix`) live outside the repo and are referenced by the flake — the repo itself is portable.

### Key files

- **`flake.nix`** — entry point; declares inputs and wires everything together into one `nixosConfiguration`. Enable/disable modules here by commenting lines in the `modules` list.
- **`settings.nix`** — single source of truth for machine identity (`username`, `hostname`, `system`, `gitName`, `gitEmail`, `shell`, `stateVersion`). Injected as `specialArgs` so every module and home-manager receive it.
- **`home.nix`** — Home Manager config for the user: git, VS Code extensions/settings.
- **`modules/`** — self-contained feature modules, each covering one domain.

### How `pkgs` flows

A single `pkgs` instance is created in `flake.nix` with `allowUnfree = true` and the `nix-vscode-extensions` overlay pre-applied (giving `pkgs.vscode-marketplace.*`). It is passed as a special arg to all NixOS modules and home-manager so they all share one instance — do not re-import nixpkgs inside modules.

### Module pattern

Each module in `modules/` is a standard NixOS module (`{ pkgs, settings, lib, ... }: { ... }`). They are unconditionally loaded when listed in `flake.nix`; to disable a module, comment it out there. No feature flags or `lib.mkIf` are needed for toggling.

### NixOS-specific workarounds

Several modules include NixOS-specific shims that are easy to break accidentally:

- **`python.nix`** — `pyenv-install` is a wrapper around `pyenv install` that injects the correct Nix store library paths (`LDFLAGS`, `CPPFLAGS`, etc.) needed to compile CPython. Use `pyenv-install` instead of plain `pyenv install`.
- **`flutter.nix`** — enables `programs.nix-ld` so FVM-downloaded Flutter binaries (which are FHS-compiled) can run on NixOS. `CHROME_EXECUTABLE` points to the Nix-managed Chromium.
- **`claude.nix`** — wraps the Claude Code CLI with bubblewrap, restricting it to `~/Development` with read-only system access. `claude-unsafe` is the unrestricted escape hatch.

## Adding a Module

1. Create `modules/my-module.nix` following the existing module pattern.
2. Add `./modules/my-module.nix` to the `modules` list in `flake.nix`.
3. Run `~/nixos-config/rebuild.sh`.
