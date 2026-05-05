{  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, nix-vscode-extensions, ... }:
    let
      settings = import ./settings.nix;
      vscode-marketplace = nix-vscode-extensions.extensions.${settings.system}.vscode-marketplace;
      
      # Separate set with unfree allowed — use this for unfree extensions like Pylance
      vscode-marketplace-unfree = (import nixpkgs {
        system = settings.system;
        config.allowUnfree = true;
        overlays = [ nix-vscode-extensions.overlays.default ];
      }).vscode-marketplace;
    in {
      nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
        system = settings.system;
        specialArgs = { inherit settings vscode-marketplace vscode-marketplace-unfree; };
        modules = [
          /etc/nixos/hardware-configuration.nix
          /etc/nixos/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit settings vscode-marketplace vscode-marketplace-unfree; };
            home-manager.users.${settings.username} = import ./home.nix;
          }

          # add modules here
          ./modules/flatpak.nix
          ./modules/gnome.nix
          ./modules/dev-tools.nix
          ./modules/java.nix
          ./modules/android.nix
          ./modules/flutter.nix
          ./modules/python.nix
        ];
      };
    };
}
