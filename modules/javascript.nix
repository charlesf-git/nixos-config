{ pkgs, settings, lib, ... }: {
  environment.systemPackages = with pkgs; [
    fnm
    bun
  ];

  # fnm downloads pre-compiled Node.js binaries built for standard Linux (FHS).
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
    programs.bash = lib.mkIf (settings.shell == "bash") {
      enable = true;
      initExtra = ''
        eval "$(fnm env --use-on-cd --shell bash)"
      '';
    };

    programs.zsh = lib.mkIf (settings.shell == "zsh") {
      enable = true;
      initExtra = ''
        eval "$(fnm env --use-on-cd --shell zsh)"
      '';
    };
  };
}
