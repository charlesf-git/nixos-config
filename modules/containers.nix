{ pkgs, settings, ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;   # aliases docker -> podman, docker-compatible socket
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    distrobox
    podman-compose
    podman-desktop
    buildah
    skopeo
  ];

  services.flatpak.packages = [
    "com.usebottles.bottles"
  ];
}
