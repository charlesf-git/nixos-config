{ config, pkgs, settings, lib, ... }:
let
  pyenvInit = ''
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  '';

  # Wrapper script that sets all required Nix store library paths
  # before calling pyenv install, since pyenv compiles Python from source
  pyenv-install = pkgs.writeShellScriptBin "pyenv-install" ''
    export CPPFLAGS="\
      -I${pkgs.zlib.dev}/include \
      -I${pkgs.libffi.dev}/include \
      -I${pkgs.readline.dev}/include \
      -I${pkgs.bzip2.dev}/include \
      -I${pkgs.openssl.dev}/include \
      -I${pkgs.ncurses.dev}/include \
      -I${pkgs.sqlite.dev}/include \
      -I${pkgs.xz.dev}/include \
      -I${pkgs.tk}/include"
    export LDFLAGS="\
      -L${pkgs.zlib.out}/lib \
      -L${pkgs.libffi.out}/lib \
      -L${pkgs.readline.out}/lib \
      -L${pkgs.bzip2.out}/lib \
      -L${pkgs.openssl.out}/lib \
      -L${pkgs.ncurses.out}/lib \
      -L${pkgs.sqlite.out}/lib \
      -L${pkgs.xz.out}/lib \
      -L${pkgs.tk}/lib"
    export CONFIGURE_OPTS="--with-openssl=${pkgs.openssl.dev}"
    export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"
    exec ${pkgs.pyenv}/bin/pyenv install "$@"
  '';
in {

  environment.systemPackages = with pkgs; [
    pyenv
    pyenv-install    # use this instead of plain `pyenv install`
    gcc
    gnumake
    zlib
    libffi
    readline
    bzip2
    openssl
    ncurses
    sqlite
    xz
    tk
    expat
  ];

  environment.sessionVariables = {
    PYENV_ROOT = "$HOME/.pyenv";
    PYENV_VIRTUALENV_DISABLE_PROMPT = "1";
  };

  home-manager.users.${settings.username} = {

    home.sessionPath = [
      "$HOME/.pyenv/bin"
      "$HOME/.pyenv/shims"
    ];

    programs.bash = lib.mkIf (settings.shell == "bash") {
      enable = true;
      initExtra = pyenvInit;
    };

    programs.zsh = lib.mkIf (settings.shell == "zsh") {
      enable = true;
      initExtra = pyenvInit;
    };
  };
}