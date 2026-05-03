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
  
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
      esbenp.prettier-vscode
      pkief.material-icon-theme
    ];
    userSettings = {
      "workbench.iconTheme" = "material-icon-theme";
    };
  };
}
