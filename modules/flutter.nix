{ config, pkgs, settings, ... }: {

  environment.systemPackages = with pkgs; [
    fvm
    chromium
  ];

  environment.sessionVariables = {
    CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
  };

  # Add fvm Flutter SDK to PATH via home-manager
  home-manager.users.${settings.username}.home.sessionPath = [
    "$HOME/fvm/default/bin"
  ];

  # Required for fvm-downloaded Flutter/Dart binaries to run on NixOS.
  # fvm downloads pre-compiled binaries built for standard Linux (FHS),
  # which expect the dynamic linker at /lib64/ld-linux-x86-64.so.2.
  # nix-ld provides a stub at that path so they can start normally.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Common libraries Flutter/Dart binaries depend on
      stdenv.cc.cc.lib    # libstdc++
      zlib
      glib
      gtk3
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      libGL
      fontconfig
      freetype
    ];
  };
}