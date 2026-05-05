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
      # General
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      pkief.material-icon-theme

      # Nix
      bbenoist.nix
      jnoortheen.nix-ide

      # Python
      ms-python.python
      ms-python.debugpy
      charliermarsh.ruff
      ms-toolsai.jupyter
      pkgs.vscode-marketplace.ms-python.vscode-pylance

      # Flutter / Dart
      dart-code.dart-code
      dart-code.flutter
    ];
    userSettings = {
      "workbench.iconTheme" = "material-icon-theme";

      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.ruff" = "explicit";
          "source.organizeImports.ruff" = "explicit";
        };
      };
      
      "python.terminal.activateEnvironment" = true;
    };
  };
}
