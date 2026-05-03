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
      gnome-console
    ];

    # Install GNOME apps
    environment.systemPackages = with pkgs; [
      gnome-terminal
    ];

    # Set GNOME Terminal as the default terminal via dconf
    home-manager.users.${settings.username}.dconf.settings = {
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "gnome-terminal";
        exec-arg = "-x";
      };

      # Optional: set a sensible default profile
      # Run `dconf watch /` in a terminal while changing settings
      # in GNOME Terminal to discover the profile UUID and keys
      "org/gnome/terminal/legacy" = {
        default-show-menubar = false;
        theme-variant = "dark";
      };
    };

    # Flatpak apps only relevant on GNOME
    services.flatpak.packages = [
      "com.mattjakeman.ExtensionManager"
    ];
  };
}