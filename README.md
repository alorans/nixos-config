## Resources

- [Installing from Minimal USB](./resources/installing_from_minimal_usb.md)
- [Nix Cheatsheet](./resources/nix_cheatsheet.md)
- [System Cheatsheet](./resources/system_cheatsheet.md)

## Installing

```sh
git clone --depth=1 https://github.com/alorans/nixos-config.git
rm nixos-config/hardware-configuration.nix
nixos-generate-config --dir nixos-config
git -C nixos-config add hardware-configuration.nix
sudo nixos-rebuild switch --flake ./nixos-config#nixos
```
