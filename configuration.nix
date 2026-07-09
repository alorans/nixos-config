# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # turn on flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Include the results of the hardware scan.
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support
  services.libinput.enable = true;

  # Enable KDE Plasma
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.libinput.touchpad = {
    # Default
    naturalScrolling = false;
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # mullvad (eventually replace with i2p)
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alorans = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" ];
  };

  # although this could be configured via profiles in home-manager,
  # this will install extensions and config on all profiles
  programs.firefox = {
    enable = true;

    policies = {
      OfferToSaveLogins = false;

      # Extensions
      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        # "*".installation_mode = "blocked";
        # turn on if you want to block the installation of extra extensions

        "uBlock0@raymondhill.net" = {
          install_url       = moz "ublock-origin";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        # KDE Plasma integration
        "plasma-browser-integration@kde.org" = {
          install_url       = moz "plasma-integration";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          install_url       = moz "noscript";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };
      };
    };

    # KDE Plasma integration
    nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  # Steam needs to be installed globally
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # magical shim that lets dynamically linked elfs run on nixos
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add commonly needed libraries for unpatched binaries here
    # you can use ldd to get the needed libraries (or readelf if you can't risk the elf running)
    stdenv.cc.cc
    zlib
    glib
    libX11
    ncurses
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    tmux
    tree
    # control screen brightness from TTY
    brightnessctl
    # check battery from TTY
    acpi
  ] ++ (with pkgs.kdePackages; [
    sddm-kcm
    partitionmanager
  ]) ++ [
    hardinfo2
    wayland-utils
    wl-clipboard
  ];

  # GPG keys
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  systemd.services.night-shutdown = {
    description = "Automatically shutdown after 12 AM and before 5 AM";
    after = [ "time-sync.target" ];
    wants = [ "time-sync.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.writeScript "night-shutdown" ''
      #!${pkgs.python3}/bin/python3
      import time
      import subprocess

      def waitUntilNight(start_hour: int, end_hour: int):
          localtime = time.localtime()
          if localtime.tm_hour < end_hour or localtime.tm_hour >= start_hour:
              return
          else:
              remaining_secs = (start_hour * 60 * 60) - (localtime.tm_hour * 60 * 60) - (localtime.tm_min * 60) - localtime.tm_sec
              time.sleep(remaining_secs)
              return

      if __name__ == "__main__":
          waitUntilNight(24, 5)
          subprocess.run(["${pkgs.systemd}/bin/shutdown", "now"])
    ''}";
  };

  # networking.firewall.allowedTCPPorts = [ 22 ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
