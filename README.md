# nixos-config
My NixOs module library. Machine-specific details (hardware, personal info) stay in `/etc/nixos` and are never committed to this repo.

## Table of Contents
- [Setting up a new machine](#setting-up-a-new-machine)
- [Add a new module](#adding-a-new-module)
- [Python development](#python-development)
- [Android development](#android-development)
- [Flutter development](#flutter-development)

## Setting up a new machine

### 1. Boot into NixOS and get git temporarily
```bash
nix-shell -p git
```

### 2. Clone this repo
```bash
git clone https://github.com/charlesf-git/nixos-config.git ~/nixos-config
```

### 3. Edit `settings.nix` file and fill your details

### 4. Choose your modules
In `flake.nix`, comment the modules you want disabled:
```nix
./modules/dev-tools.nix
# ./modules/flutter.nix
```
### 5. Enable flakes in /etc/nixos/configuration.nix

Add this line if it isn't already there:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ]
```

Apply these changes once with the old rebuild command:
```bash
sudo nixos-rebuild switch
```

### 6. All future rebuilds using `rebuild.sh`
```bash
~/nixos-config/rebuild.sh
```

## Adding a new module
1. Create `modules/my-module.nix`
2. Add it in `flake.nix`
3. Run `~/nixos-config/rebuild.sh`
4. Commit and push

## Python Development


Python versions are managed with `pyenv`. After a fresh setup or new machine, install a Python version using the custom wrapper (required on NixOS):

```bash
# Use pyenv-install instead of plain `pyenv install`
# This sets the correct Nix store library paths for compiling Python
pyenv-install 3.12.3

# Set it as the global default
pyenv global 3.12.3

# Verify
python --version
```

### Per-project Python versions

```bash
cd ~/projects/my-app

# Set a specific Python version for this project
# Creates a .python-version file in the project directory
pyenv local 3.11.8

# Create and activate a virtual environment
pyenv virtualenv 3.11.8 my-app-env
pyenv activate my-app-env

# Install dependencies as usual
pip install -r requirements.txt
```

### Useful pyenv commands

| Command | What it does |
|---|---|
| `pyenv-install 3.12.3` | Install a Python version (use this instead of `pyenv install`) |
| `pyenv versions` | List all installed Python versions |
| `pyenv global 3.12.3` | Set the global default Python version |
| `pyenv local 3.11.8` | Set a per-project Python version |
| `pyenv virtualenv 3.12.3 myenv` | Create a virtual environment |
| `pyenv activate myenv` | Activate a virtual environment |
| `pyenv deactivate` | Deactivate current virtual environment |
| `pyenv uninstall 3.11.8` | Remove a Python version |


## Android development

Android Studio manages its own SDK, so after a fresh setup you need to complete the first-run wizard before Flutter or terminal-based Android tools will work.

### First-time setup

1. Open **Android Studio** from the app grid
2. Complete the **Setup Wizard** — it will download the Android SDK into `~/Android/Sdk`
3. Once the wizard finishes, install the required SDK tools:
   - Go to **Settings → Languages & Frameworks → Android SDK**
   - Under **SDK Platforms** — install your target Android version
   - Under **SDK Tools** — make sure these are checked:
     - Android SDK Build-Tools
     - Android SDK Platform-Tools
     - Android SDK Command-line Tools
     - Android Emulator

## Flutter development

Flutter versions are managed with `fvm` (Flutter Version Manager). After a fresh setup, install a Flutter version and complete the Android setup first before running Flutter.

### First-time setup

```bash
# Install the stable Flutter version
fvm install stable

# Set it as the global default
fvm global stable

# Disable platforms you won't be using
fvm flutter config --no-enable-linux-desktop
fvm flutter config --no-enable-windows-desktop

# Verify the setup — Android toolchain should be green
# Web and Linux errors are fine to ignore if not targeting those platforms
fvm flutter doctor
```