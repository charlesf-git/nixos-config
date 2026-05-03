{ config, pkgs, lib, settings, ... }: {

  # This entire block will only be applied if GNOME is the active desktop
  config = lib.mkIf config.services.desktopManager.gnome.enable {
    # Remove unwanted GNOME apps that come bundled by default
    environment.gnome.excludePackages = with pkgs; [
      epiphany # Web
      geary
      totem # Videos
      showtime # Video Player
      decibels # Audio Player
      gnome-contacts
      gnome-weather
      gnome-maps
      gnome-music
      gnome-tour
      simple-scan # Document Scanner
      gnome-console
      gnome-software
      gnome-connections
      yelp
      seahorse # Password and Keys
      xterm
      #loupe #Image Viewer
      #papers  #Document Viewer
    ];

    # Install GNOME apps
    environment.systemPackages = with pkgs; [
      gnome-terminal
      gnomeExtensions.dash-to-dock
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

      # Show minimize and maximize buttons alongside close
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      # Enable dash-to-dock extension
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "dash-to-dock@micxgx.gmail.com"
        ];
      };

      # Optional: configure dash-to-dock behaviour
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        intellihide = true;
        show-trash = false;
      };
    };
  };
}
