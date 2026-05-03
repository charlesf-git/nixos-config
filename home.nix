{ config, pkgs, ... }:
let
  settings = import ./settings.nix;
in {
  home.stateVersion = settings.stateVersion;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = settings.gitName;
    userEmail = settings.gitEmail;
    extraConfig = {
      credential.helper = "libsecret";
      pull.rebase = false;
      init.defaultBranch = "main";
    };
  };

  # Set VLC as the default app for video and audio files
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Video
      "video/mp4"       = "org.videolan.VLC.desktop";
      "video/mkv"       = "org.videolan.VLC.desktop";
      "video/x-matroska"= "org.videolan.VLC.desktop";
      "video/mpeg"      = "org.videolan.VLC.desktop";
      "video/quicktime" = "org.videolan.VLC.desktop";
      "video/x-msvideo" = "org.videolan.VLC.desktop";  # .avi
      "video/webm"      = "org.videolan.VLC.desktop";
      "video/ogg"       = "org.videolan.VLC.desktop";

      # Audio
      "audio/mpeg"      = "org.videolan.VLC.desktop";  # .mp3
      "audio/mp4"       = "org.videolan.VLC.desktop";  # .m4a
      "audio/flac"      = "org.videolan.VLC.desktop";
      "audio/ogg"       = "org.videolan.VLC.desktop";
      "audio/x-wav"     = "org.videolan.VLC.desktop";
      "audio/aac"       = "org.videolan.VLC.desktop";
      "audio/opus"      = "org.videolan.VLC.desktop";
    };
  };
}