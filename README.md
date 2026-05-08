# nixos-config

A flake-based, modular NixOS configuration. Machine-specific files (`hardware-configuration.nix`, `configuration.nix`) live in `/etc/nixos` and are never committed — this repo is fully portable.

## Table of Contents
- [Architecture](#architecture)
- [Modules](#modules)
- [Setting up a new machine](#setting-up-a-new-machine)
- [Adding a module](#adding-a-module)
- [Python development](#python-development)
- [Android development](#android-development)
- [Flutter development](#flutter-development)
- [JavaScript / Node.js development](#javascript--nodejs-development)
- [Rust development](#rust-development)
- [Containers](#containers)

## Architecture

| File | Role |
|---|---|
| `flake.nix` | Entry point. Enable/disable modules by commenting lines in the `modules` list. |
| `settings.nix` | Single source of truth for `username`, `hostname`, `system`, `gitName`, `gitEmail`, `shell`, `stateVersion`. |
| `home.nix` | Home Manager config: git, VS Code extensions and settings. |
| `modules/` | Self-contained feature modules, one per domain. |

A single `pkgs` instance is created in `flake.nix` with `allowUnfree = true` and the `nix-vscode-extensions` overlay applied. All modules and Home Manager share this instance — do not re-import nixpkgs inside modules.

## Modules

| Module | What it provides |
|---|---|
| `flatpak.nix` | Flatpak via nix-flatpak; installs Brave, Flatseal, VLC, Inkscape, and more from Flathub. |
| `gnome.nix` | Strips unwanted GNOME defaults; applies only when GNOME is the active desktop. |
| `dev-tools.nix` | Core CLI tools: git, curl, wget, ripgrep, fd, htop, beekeeper-studio. |
| `claude.nix` | Claude Code CLI sandboxed to `~/Development` via bubblewrap; `claude-unsafe` escapes the sandbox. |
| `java.nix` | JDK 17 as the system default plus Gradle and Maven. |
| `android.nix` | Android Studio, KVM acceleration for the emulator, `ANDROID_HOME` env vars. |
| `flutter.nix` | FVM, nix-ld for FHS binaries, Chromium as `CHROME_EXECUTABLE`, `android-setup` helper script. |
| `python.nix` | pyenv plus the `pyenv-install` wrapper that injects Nix store library paths for compiling CPython. |
| `containers.nix` | Podman with Docker compat, container DNS, distrobox, podman-compose, Bottles via Flatpak. |
| `javascript.nix` | `fnm` for Node version management, `bun` runtime, nix-ld for FHS Node binaries. |
| `rust.nix` | `rustup`, `gcc` linker, nix-ld for FHS Rust toolchain binaries. |

## Setting up a new machine

### 1. Enable flakes in `/etc/nixos/configuration.nix`
Open the file with nano:
```bash
sudo nano /etc/nixos/configuration.nix
```
Add this line if it isn't already present:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
Save with `Ctrl+O` → `Enter`, then exit with `Ctrl+X`. Apply the change:
```bash
sudo nixos-rebuild switch
```

### 2. Get git temporarily
`nix-shell -p git` drops you into a temporary shell with `git` available without permanently installing it. On NixOS, packages aren't installed globally by default — `nix-shell -p` is the standard way to pull in a tool for one-off use. Once you exit the shell, git is gone.
```bash
nix-shell -p git
```

### 3. Clone this repo
```bash
git clone https://github.com/charlesf-git/nixos-config.git ~/nixos-config
```

### 4. Fill in `settings.nix`
Edit `~/nixos-config/settings.nix` and set `username`, `hostname`, `system`, `gitName`, `gitEmail`, `shell`, and `stateVersion` to match your machine.

### 5. Choose your modules
In `flake.nix`, comment out any modules you don't need:
```nix
./modules/dev-tools.nix
# ./modules/flutter.nix   # comment to disable
```

### 6. All future rebuilds use `rebuild.sh`
```bash
~/nixos-config/rebuild.sh
```
This runs `sudo nixos-rebuild switch --flake ~/nixos-config#<hostname> --impure`. The `--impure` flag is required because `flake.nix` imports `settings.nix` at evaluation time.

## Adding a module

1. Create `modules/my-module.nix` following the existing module pattern.
2. Add `./modules/my-module.nix` to the `modules` list in `flake.nix`.
3. Run `~/nixos-config/rebuild.sh`.

## Python development

Python versions are managed with `pyenv`. Always use the `pyenv-install` wrapper instead of plain `pyenv install` — it injects the correct Nix store library paths needed to compile CPython from source.

```bash
pyenv-install 3.12.3
pyenv global 3.12.3
python --version
```

### Per-project versions
```bash
cd ~/projects/my-app

# Pin the Python version for this project (writes .python-version)
pyenv local 3.11.8

# Create a .venv in the project directory and activate it
python -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt

# After installing new packages, update requirements.txt
pip freeze > requirements.txt
```

### Quick reference

| Command | What it does |
|---|---|
| `pyenv-install 3.12.3` | Install a Python version (NixOS-compatible wrapper) |
| `pyenv versions` | List installed versions |
| `pyenv global 3.12.3` | Set system-wide default |
| `pyenv local 3.11.8` | Set per-project version (writes `.python-version`) |
| `python -m venv .venv` | Create a virtual environment in the project directory |
| `source .venv/bin/activate` | Activate the virtual environment |
| `deactivate` | Deactivate the virtual environment |
| `pyenv uninstall 3.11.8` | Remove a version |

## Android development

Android Studio manages its own SDK. Complete the first-run wizard before using Flutter or any terminal-based Android tools.

### First-time setup

1. Open **Android Studio** from the app grid.
2. Complete the **Setup Wizard** — it downloads the SDK into `~/Android/Sdk`.
3. Go to **Settings → Languages & Frameworks → Android SDK** and confirm these are installed:
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Command-line Tools
   - Android Emulator

### Emulator performance

The `android-setup` helper script applies persistent performance settings (disables animations, suppresses error dialogs) to a running emulator. Run it once after the first boot of a new AVD:
```bash
android-setup
```

## Flutter development

Flutter versions are managed with `fvm`. Complete the Android setup first.

### First-time setup

```bash
fvm install stable
fvm global stable

# Disable platforms you won't target
fvm flutter config --no-enable-linux-desktop
fvm flutter config --no-enable-windows-desktop

# Android toolchain should be green; web/Linux errors are safe to ignore
fvm flutter doctor
```

## JavaScript / Node.js development

Node versions are managed with `fnm`, which auto-switches when you `cd` into a directory that has `.node-version` or `.nvmrc`.

```bash
fnm install 22
fnm use 22
node --version
```

Use `bun` as the runtime and package manager for new projects.

## Rust development

Rust toolchains are managed with `rustup`.

```bash
rustup toolchain install stable
rustup default stable
cargo --version
```

## Containers

Podman is installed with Docker compatibility (`docker` → `podman` alias and a Docker-compatible socket). Container DNS is enabled by default.

```bash
docker run --rm hello-world    # works via podman compat
podman-compose up              # docker-compose equivalent
distrobox create --name dev --image ubuntu:24.04
distrobox enter dev
```
