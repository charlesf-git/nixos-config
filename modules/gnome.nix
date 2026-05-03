{ config, pkgs, lib, ... }: {

  # This entire block will only be applied if GNOME is the active desktop
  config = lib.mkIf config.services.desktopManager.gnome.enable {
    # Remove unwanted GNOME apps that come bundled by default
    environment.gnome.excludePackages = with pkgs; [
      epiphany # Web
      geary
      totem # Video Player
      gnome-contacts
      gnome-weather
      gnome-maps
      gnome-music
      gnome-tour
      simple-scan # Document Scanner
    ];

    # Flatpak apps only relevant on GNOME
    services.flatpak.packages = [
      "com.mattjakeman.ExtensionManager"
    ];
  };
}