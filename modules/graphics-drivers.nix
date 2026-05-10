{ config, pkgs, lib, settings, ... }: {

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers =
    lib.mkIf (settings.gpu == "nvidia" || settings.gpu == "nvidia-old") [ "nvidia" ];

  hardware.nvidia = lib.mkIf (settings.gpu == "nvidia" || settings.gpu == "nvidia-old") {
    modesetting.enable = true;
    open = settings.gpu == "nvidia";   # open kernel module requires Turing (RTX) or newer
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
