{ config, pkgs, settings, lib, ... }:
let
  vlc = "org.videolan.VLC.desktop";
  isGnome = config.services.desktopManager.gnome.enable;
in {
  services.flatpak = {
    enable = true;

    # Flathub is added automatically by nix-flatpak as the default remote
    
    # List of apps to install - use the Flatpak app ID from flathub.org
    packages = [
      "com.brave.Browser"
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse"
      "org.videolan.VLC"
      "io.github.peazip.PeaZip"
      "io.github.ellie_commons.cherrypick"
      "org.inkscape.Inkscape"
      "org.gnome.meld"
      "me.iepure.devtoolbox"
      "com.getpostman.Postman"
    ] ++ lib.optionals isGnome [
      "com.mattjakeman.ExtensionManager"
    ];

    # Keep all declared Flatpaks up to date on each rebuild
    update.onActivation = true;
  };
  
  home-manager.users.${settings.username}.xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4"        = vlc;
      "video/mkv"        = vlc;
      "video/x-matroska" = vlc;
      "video/mpeg"       = vlc;
      "video/quicktime"  = vlc;
      "video/x-msvideo"  = vlc;
      "video/webm"       = vlc;
      "video/ogg"        = vlc;
      "audio/mpeg"       = vlc;
      "audio/mp4"        = vlc;
      "audio/flac"       = vlc;
      "audio/ogg"        = vlc;
      "audio/x-wav"      = vlc;
      "audio/aac"        = vlc;
      "audio/opus"       = vlc;
    };
  };
}
