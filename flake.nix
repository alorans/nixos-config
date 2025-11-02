{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager";

    # home-manager nixpkgs follows main nixpkgs
    # this can slightly affect reproducibility, but it can dramatically reduce download sizes
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.memex = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit nixpkgs-unstable; }; # pass unstable to configuration.nix
      modules = [
        ./configuration.nix
      ];
    };
  };
}
