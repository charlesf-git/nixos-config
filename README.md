# nixos-config
My NixOs module library. Machine-specific details (hardware, personal info) stay in `/etc/nixos` and are never committed to this repo.

## Modules
| Module | What is adds |
|---|---|
| `devTools` | gitFull, VS Code, curl, ripgrep, fd, htop |

## Setting up new machine

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