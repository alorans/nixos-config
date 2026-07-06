{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
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
    }:
    let
      # the goal here is to wrap all of these inputs into one pkgs argument
      overlays = [
        # pkgs.unstable
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        })

        # vscode extensions
        nix-vscode-extensions.overlays.default

        # make the ui of ghidra bigger than default, not for everyone
        # also it forces ghidra to be compiled from source which takes a minute
        (final: prev: {
          ghidra = prev.ghidra.overrideAttrs (old: {
            # this may not support non-integer values
            postInstall = (old.postInstall or "") + ''
              substituteInPlace $out/lib/ghidra/support/launch.properties \
                --replace-fail \
                "VMARGS_LINUX=-Dsun.java2d.uiScale=1" \
                "VMARGS_LINUX=-Dsun.java2d.uiScale=2"
            '';
          });
        })
        
        # improved rsibreak
        (final: prev: {
          rsibreak = prev.rsibreak.overrideAttrs (old: {
            version = "xwayland-0.13.0";

            src = final.fetchFromGitHub {
              owner = "alorans";
              repo = "rsibreak_xwayland";
              rev = "6200e975865f8e276848ec3e7596b422cdda748f"; # copy the most recent commit hash
              hash = "sha256-yuVGrTlDd2YxXvsks8httNie5v/t6D0KZoCeC69gap8="; # nix will tell you what to put if you leave it blank
            };

            # wayland build inputs
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
              final.pkg-config
              final.wayland-scanner
            ];
            buildInputs = (old.buildInputs or []) ++ [
              final.wayland
              final.wayland-protocols
            ];

            # load in xwayland
            postFixup = (old.postFixup or "") + ''
              wrapProgram $out/bin/rsibreak --set QT_QPA_PLATFORM xcb
            '';
          });
        })
      ];
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit nixpkgs-unstable nix-vscode-extensions; };
        modules = [
          { nixpkgs.overlays = overlays; }
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            home-manager.users.alorans = import ./home.nix;
            home-manager.backupFileExtension = "hm-bak";
          }
        ];
      };
    };
}