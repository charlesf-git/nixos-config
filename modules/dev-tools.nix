{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    gitFull
    curl
    wget
    htop
    ripgrep
    fd
    unzip
  ];
  
  programs.vscode = [
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
      esbenp.prettier-vscode
      dbaemer.vscode-eslint\
    ];
  ];
}
