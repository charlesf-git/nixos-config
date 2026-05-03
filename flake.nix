{
  description = "Developer NixOS modules";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosModules = {
      # add modules here. Example:
      # moduleName = import ./modules/moduleName.nix;
      devTools = import ./modules/dev-tools.nix
    };
    
    inherit home-manager;
  };
}
