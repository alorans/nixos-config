# Intro
- NixOS is an interesting Linux distro because it intentionally diverges from the standard FSH (Filesystem Hierarchy) for Linux.
- Additionally, it's focus on declarative management of system resources means that guides written for installing Arch, Gentoo, or similar minimal distros do not work on NixOS.
# Downloading & Booting
- Download the latest NixOS Minimal ISO (should be <2GB)
	- The graphical installer is actually pretty good, so definitely use that (and discard the rest of this guide) if you're not familiar with the command line.
- Flash it to a USB drive
- Shut down your computer fully and reboot into the BIOS/temp boot settings
- Boot into the USB HDD drive
# Networking
```sh
sudo systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "Your Network Name Here"
> set_network 0 psk "Your Network Password Here"
> enable_network 0
> quit
ping gnu.org  # testing
```
# Helpful Programs
```sh
nix-shell -p git vim tmux tree acpi brightnessctl
```
- `acpi` = check laptop battery
- `brightnessctl` = change screen brightness
- I typically boot into the nix-shell above, then `tmux`, and finally `sudo -i` for convenience in the installation.
- If you don't do `sudo -i`, most of the following commands will have to be run with `sudo`.
# Partition Disk
- **CHECK YOUR DISKS IN `/dev`!**
	- Typically, hard drives are at `/dev/sdX`
		- E.g. `/dev/sda`
	- Modern SSDs are at `/dev/nvmeXnY`
		- E.g. `/dev/nvme0n1`
	- Virtual hard drives are at `/dev/vdX`
		- E.g. `/dev/vda`
- You can declaratively partition a disk with **disko** (nix-community), and it's actually pretty straight-forward. I just find gdisk faster for one-time configurations.
```sh
gdisk /dev/nvme0n1
> o  # new GUID Partition Table
> y
> n  # new partition
> <Enter>  # default partition number (should be 1)
> <Enter>  # default starting block
> +512M  # 512MB boot partition
> ef00  # partition type is EFI System
> n
> <Enter>  # partition 2
> <Enter>
> -16G  # leave space for swap
> 8300  # Linux filesystem
> n
> <Enter>  # partition 3
> <Enter>
> <Enter>  # use remaining space
> 8200  # Linux swap
> w  # write the partition table (careful: WIPES DISK!)
> y
```
- NOTE: swap is great, but it can wear down SSDs over time, so be mindful of that.
# Make Filesystems
- Make a FAT32 filesystem with the label ESP (EFI System Partition) on partition number 1.
```sh
mkfs.fat -F 32 -n ESP /dev/nvme0n1p1  # -I to force
```
- Make your main ext4 filesystem on partition 2.
```sh
mkfs.ext4 -L NIXOS /dev/nvme0n1p2  # -f to force
```
- Make the swap partition.
```sh
mkswap -L SWAP /dev/nvme0n1p3  # -f to force
```
- NOTE: the labels (ESP, NIXOS, SWAP) are linked under /dev/disk/by-label/
# Mount Filesystems
- Mount the main filesystem.
```sh
mount /mnt -L NIXOS
```
- Mount the boot partition.
```sh
mkdir -p /mnt/boot  # -p is there so the command works out of context
mount /mnt/boot -L ESP
```
- Run `findmnt` (or `mount` by itself) to list and verify the currently mounted filesystems.
- Run `umount` to unmount filesystems.
	- E.g. `umount /mnt/boot && umount /mnt`
	- NOTE: there's no 'n' in `umount`.
- **(optional)** Enable the swap partition.
	- This is particularly useful if you want to `git clone` a large configuration which might use a lot of RAM to build.
	- It's optional because `hardware-configuration.nix` (when we create it) will automatically load the swap drive when we first reboot into the new system.
	- In fact, we don't need to deal with `/etc/fstab` at all in NixOS.
```sh
swapon -L SWAP
```
- Run `swapon --show` to verify the swap drive.
- Run `swapoff` to disable the partition for swapping.
	- E.g. `swapoff -L SWAP`
# Make Your Configuration
- Generate `hardware-configuration.nix` and template `configuration.nix`.
```sh
nixos-generate-config --root /mnt
```
- Edit `/mnt/etc/nixos/configuration.nix` with vim or nano to make your configuration.
- Alternatively, you can get a configuration from the internet.
```sh
git clone --depth 1 "Your Configuration Repo URL Here" /mnt/etc/nixos
```
- Install NixOS
```sh
nixos-install
# or if your configuration uses flakes
nixos-install --flake 'path/to/flake.nix#yourconfigurationnamehere'
```
- Enter the installation and set a password, if you defined a regular user in your `configuration.nix`.
```sh
nixos-enter --root /mnt -c 'passwd YourUsernameHere'
```
- If all has gone well, reboot. You should see the GRUB boot menu with one NixOS configuration available.
```sh
reboot
```
