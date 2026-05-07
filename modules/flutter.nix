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

    home.activation.patchAndroidEmulator =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Patch QEMU to use the nix-ld interceptor so NIX_LD_LIBRARY_PATH is honoured
        QEMU="$HOME/Android/Sdk/emulator/qemu/linux-x86_64/qemu-system-x86_64"
        if [ -f "$QEMU" ] && [ -w "$QEMU" ]; then
          ${pkgs.patchelf}/bin/patchelf \
            --set-interpreter /lib64/ld-linux-x86-64.so.2 \
            "$QEMU" \
            && echo "android emulator: patched qemu interpreter" \
            || echo "android emulator: failed to patch qemu interpreter"
        fi

        # Patch the Qt xcb plugin RPATH so it finds its bundled xcb libs and
        # nix-ld system libs even after the emulator resets LD_LIBRARY_PATH
        LIBQXCB="$HOME/Android/Sdk/emulator/lib64/qt/plugins/platforms/libqxcbAndroidEmu.so"
        if [ -f "$LIBQXCB" ] && [ -w "$LIBQXCB" ]; then
          ${pkgs.patchelf}/bin/patchelf \
            --set-rpath '$ORIGIN/../../lib:/run/current-system/sw/share/nix-ld/lib' \
            "$LIBQXCB" \
            && echo "android emulator: patched libqxcb rpath" \
            || echo "android emulator: failed to patch libqxcb rpath"
        fi
      '';
  };

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
      libbsd
      libmd
      pixman
      libjpeg
      libcap
      libusb1
      snappy
      xcb-util-cursor
      xorg.xcbutil
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      # Missing deps of the bundled Qt xcb platform plugin
      xorg.libSM
      xorg.libICE
      llvmPackages.libcxx
    ];
  };
}
