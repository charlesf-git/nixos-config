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

### 3. Copy the example settings file and fill your details
```bash
cp ~/nixos-config/settings.example.nix ~/nixos-config/settings.nix
```

Then edit `settings.nix` with your personal details.

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