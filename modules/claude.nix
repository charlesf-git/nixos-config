{ config, pkgs, settings, lib, ... }: {

  environment.systemPackages = with pkgs; [
    claude-code
  ];

  # Optional: add a shorter alias
  home-manager.users.${settings.username} = {
    programs.bash = lib.mkIf (settings.shell == "bash") {
      shellAliases = {
        cc = "claude";
      };
    };

    programs.zsh = lib.mkIf (settings.shell == "zsh") {
      shellAliases = {
        cc = "claude";
      };
    };
  };
}