{ config, pkgs, settings, lib, ... }: {

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
      	name = "flatpark";
      	location = "https://dl.flatpark.org/flatpark.flatpakrepo";
      }
    ];

    packages = [
      { appId = "com.brave.Browser"; origin = "flathub"; }
      { appId = "org.gnome.Papers"; origin = "flathub"; }
      { appId = "org.gnome.Showtime"; origin = "flathub"; }
      { appId = "org.gnome.Decibels"; origin = "flathub"; }
      { appId = "org.videolan.VLC"; origin = "flathub"; }
      { appId = "org.gnome.Loupe"; origin = "flathub"; }
      { appId = "org.libreoffice.LibreOffice"; origin = "flathub"; }

      { appId = "dev.zed.Zed"; origin = "flathub"; }
      { appId = "io.github.db_mobile.resonance"; origin = "flathub"; }
      { appId = "page.codeberg.elly_code.cherrypick"; origin = "flathub"; }

      { appId = "com.anthropic.ClaudeDesktop"; origin = "flatpark"; }
      { appId = "ai.storyteller.designcraft"; origin = "flatpark,"; }
      { appId = "io.github.frandavid100.leaf"; origin = "flatpark"; }
      { appId = "ely.zacharyzhang.office.tree"; origin = "flatpark"; }
      { appId = "dev.dbflux.DBFlux"; origin = "flatpark"; }
    ];

    # Keep all declared Flatpaks up to date on each rebuild
    update.onActivation = true;
  };
}
