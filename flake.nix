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

      # Single pkgs instance with allowUnfree and the vscode marketplace overlay
      # This makes pkgs.vscode-marketplace available everywhere without separate imports
      pkgs = import nixpkgs {
        system = settings.system;
        config.allowUnfree = true;
        overlays = [ nix-vscode-extensions.overlays.default ];
      };
    in {
      nixosConfigurations.${settings.hostname} = nixpkgs.lib.nixosSystem {
        system = settings.system;
        specialArgs = { inherit settings pkgs; };
        modules = [
          /etc/nixos/hardware-configuration.nix
          /etc/nixos/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;    # false because we supply our own pkgs
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit settings pkgs; };
            home-manager.users.${settings.username} = import ./home.nix;
          }
          # modules
          ./modules/graphics-drivers.nix
          ./modules/boot.nix
          ./modules/flatpak.nix
          ./modules/gnome.nix
          ./modules/dev-tools.nix
          ./modules/claude.nix
          ./modules/java.nix
          ./modules/android.nix
          ./modules/flutter.nix
          ./modules/python.nix
          ./modules/containers.nix
          ./modules/javascript.nix
          ./modules/rust.nix
          ./modules/content-filter.nix
        ];
      };
    };
}