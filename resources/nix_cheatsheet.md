# Nix Cheatsheet

- Make sure flake.nix is added to any git repositories you are in!

- Flake devShell template
```nix
TODO
```

- NixOS rebuild commands
    - `switch` = switch immediately
    - `boot` = enter new system on reboot, good for kinda risky stuff
    - `build-vm` = test big changes in a vm without touching the real system
    - `dry-build` = preview changes

- Garbage collection
    - TODO
    - `nix-collect-garbage -d`
    - `nix flake update` there is also a channels version of this
    - also home manager needs this sometimes (does it need it if it is following system nixpkgs?)
    - `nix-store --optimize` makes hard links

- I would not recommend anyone use channels unless you have used NixOS before flakes and are used to that.
- Never use `nix-env -i`.
- `nix-shell -p` is OK. There might be a flakes version of this.

- *nix-direnv*
    - This is great for quality of life.
    - Do `echo "use flake" >> .envrc && direnv allow` in the directory.