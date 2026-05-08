{ pkgs, settings, lib, ... }: {
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  boot.kernelParams = [ "quiet" "splash" ];
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
}
