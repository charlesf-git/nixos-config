{ config, pkgs, lib, settings, ... }: {

  environment.systemPackages = with pkgs; [
    fvm
    chromium
    patchelf
  ];

  environment.sessionVariables = {
    CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
  };

  home-manager.users.${settings.username} = { lib, ... }: {

    home.sessionPath = [ "$HOME/fvm/default/bin" ];

    # The Android QEMU binary was previously patched to use the real glibc linker,
    # which bypasses NIX_LD_LIBRARY_PATH entirely. This re-patches it to use the
    # nix-ld stub instead, so the libraries listed below are actually found.
    home.activation.patchAndroidEmulator =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        QEMU="$HOME/Android/Sdk/emulator/qemu/linux-x86_64/qemu-system-x86_64"
        NIX_LD_STUB="/run/current-system/sw/share/nix-ld/lib/ld.so"
        if [ -f "$QEMU" ] && [ -w "$QEMU" ] && [ -f "$NIX_LD_STUB" ]; then
          ${pkgs.patchelf}/bin/patchelf --set-interpreter "$NIX_LD_STUB" "$QEMU" \
            && echo "android emulator: patched interpreter to nix-ld stub" \
            || echo "android emulator: patchelf failed"
        fi
      '';
  };

  # nix-ld provides the FHS dynamic linker stub so pre-compiled binaries
  # (fvm Flutter/Dart, Android emulator QEMU) can find their shared libraries.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Flutter / Dart runtime
      stdenv.cc.cc.lib
      zlib
      glib
      gtk3
      libx11
      libxext
      libxrender
      libGL
      fontconfig
      freetype

      # Android emulator (QEMU)
      libpulseaudio
      alsa-lib
      libpng
      libxkbfile
      libxkbcommon
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxfixes
      libxi
      libxrandr
      libxtst
      libxshmfence
      libxau
      libxdmcp
      nss
      nspr
      dbus
      expat
      pciutils
      at-spi2-atk
      at-spi2-core
      atk
      cups
      libdrm
      mesa
      wayland
      vulkan-loader
      udev
    ];
  };
}
