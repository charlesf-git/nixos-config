{  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }:
    let
      settings = import ./settings.nix;
    in {
      nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
        system = settings.system;
        specialArgs = { inherit settings; };
        modules = [
          /etc/nixos/hardware-configuration.nix
          /etc/nixos/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit settings; };
            home-manager.users.${settings.username} = import ./home.nix;
          }

          # add modules here
          ./modules/flatpak.nix
          ./modules/gnome.nix
          ./modules/dev-tools.nix
          ./modules/java.nix
          ./modules/android.nix
          ./modules/flutter.nix
        ];
      };
    };
}
