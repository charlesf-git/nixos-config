{ config, pkgs, ... }: {
  services.flatpak = {
    enable = true;

    # Flathub is added automatically by nix-flatpak as the default remote
    
    # List of apps to install - use the Flatpak app ID from flathub.org
    packages = [
      "com.brave.Browser"
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse"
      "org.videolan.VLC"
    ];

    # Keep all declared Flatpaks up to date on each rebuild
    update.onActivation = true;
  };
}