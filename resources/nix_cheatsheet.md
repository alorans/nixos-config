# Nix Cheatsheet

- Errors
    - Always make sure your flake.nix and any paths it refers to are added to git.
    - `error: syntax error, unexpected '=', expecting ';'` generally means you forgot the semicolon on the line before.

- NixOS rebuild
    - `switch` = build and switch to new system immediately
    - `boot` = enter new system on reboot
    - `build-vm` = test big changes in a vm without touching the real system
    - `dry-build` = preview changes

- Garbage collection
    - `nix-collect-garbage -d` = delete all generations besides than the current one
    - `nix-collect-garbage --delete-older-than` = delete all generations older than a given string (e.g. `30d`, `1h`). It is possible to automate running this periodically, but I prefer to do it manually.
    - `nix-store --optimize` = make hard links to save space in the /nix/store

- Classic Nix
    - I would not recommend anyone use the classic NixOS-style configuration (i.e. with channels) unless they were using NixOS before flakes and are used to that.
    - I personally *never* use `nix-env -i`, especially seeing as we have home-manager. There might be some valid uses for it, but I think declarative installation should be strongly preferred wherever possible.
    - `nix-shell -p` is fine for temporarily testing a package. For anything tied to a specific project, it is generally better to use a classic or flake-based devShell.
    - `sudo nix-channel --update && sudo nixos-rebuild switch --upgrade` to update channels.

- Modern Nix (nix-command + flakes)
    - `nix flake update` = update the dependencies in the flake.lock file
    - `nix develop` = enter a flake.nix devShell in the same file (I usually automate this with `nix-direnv`)

- `nix-direnv`
    - This package is great for quality of life.
    - Install it alongside `direnv` and it automatically loads a devShell upon entering its directory.
    - Do `echo "use flake" >> .envrc && direnv allow` in the directory.

- Templates
    - Flake devShell
```nix
{
  description = "my devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # build-time dependencies
        nativeBuildInputs = with pkgs; [];

        # run-time dependencies
        buildInputs = with pkgs; [];

        # shell command (e.g. to export path variables)
        shellHook = '''';
      };
    };
}
```
