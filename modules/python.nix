{ pkgs, settings, ... }:
let
  python = pkgs.${settings.pythonVersion};
in {
  environment.systemPackages = [ python ];
}
