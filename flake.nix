{
  description = "baby's first nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # home-manager nixpkgs follows main nixpkgs
    # this can slightly affect reproducibility, but it can dramatically reduce download sizes
    # make home manager have same version as nixpkgs its following
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-vscode-extensions,
      home-manager,
      plasma-manager,
      ...
    }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit nixpkgs-unstable nix-vscode-extensions; }; # pass unstable to configuration.nix
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          # reuse system pkgs
          # this means that overlays and such are ignored in home.nix and must be applied in configuration.nix
          # uh i got this error:
          # evaluation warning: alorans profile: You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
          #                     This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`
          home-manager.useGlobalPkgs = true;
          # install home.packages via /etc/profiles instead of ~/.nix-profile
          home-manager.useUserPackages = true;

          # TODO: is there a more univorm way to do this with plasma-manager and all?
          home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
          home-manager.users.alorans = import ./home.nix;
          home-manager.backupFileExtension = "hm-bak"; # uncomment if home-manager complains about existing dotfiles
          # you may need to add the setting that allows it to clobber old backup files
          # actually I think this is on a per-file basis
          # so like home.file.".config/example.txt".force = true;
        }
      ];
    };
  };
}
