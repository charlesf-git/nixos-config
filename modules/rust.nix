{ pkgs, settings, lib, ... }: {
  environment.systemPackages = with pkgs; [
    rustup
    gcc   # linker required by cargo
  ];

  # rustup downloads pre-compiled Rust toolchain binaries built for standard Linux (FHS).
  # nix-ld provides the stub dynamic linker so they can start normally.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };

  home-manager.users.${settings.username} = {
    home.sessionVariables = {
      RUSTUP_HOME = "$HOME/.rustup";
      CARGO_HOME  = "$HOME/.cargo";
    };

    programs.bash = lib.mkIf (settings.shell == "bash") {
      enable = true;
      initExtra = ''
        export PATH="$HOME/.cargo/bin:$PATH"
      '';
    };

    programs.zsh = lib.mkIf (settings.shell == "zsh") {
      enable = true;
      initExtra = ''
        export PATH="$HOME/.cargo/bin:$PATH"
      '';
    };
  };
}
