{ config, pkgs, settings, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    android-studio
  ];

  # Allow emulator to use KVM hardware acceleration
  virtualisation.kvmgt.enable = true;
  users.users.${settings.username}.extraGroups = [ "kvm" ];

  environment.sessionVariables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
  };
}