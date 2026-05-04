{ config, pkgs, ... }: {

  # Default system-wide JDK — used by Android Studio, Gradle, etc.
  programs.java = {
    enable = true;
    package = pkgs.jdk17;    # system default
  };

  environment.systemPackages = with pkgs; [
    gradle
    maven
  ];
}