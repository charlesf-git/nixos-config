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
    beekeeper-studio
  ];
}
