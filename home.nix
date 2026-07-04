# Per-user configuration, managed by home-manager.
# See https://nix-community.github.io/home-manager/options.xhtml for options.

{ config, pkgs, lib, ... }:

{
  home.username = "alorans";
  home.homeDirectory = "/home/alorans";

  # This value determines the home-manager release your config is
  # compatible with. Leave it as-is after initial setup; it's not
  # tied to your nixpkgs/NixOS version.
  home.stateVersion = "25.05";

  # Let home-manager manage itself (adds the `home-manager` CLI).
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # cli
    zellij
    nh
    gh
    python3
    unstable.zig
    unstable.zls
    unstable.yt-dlp
    clang-tools
    kdiff3
    ffmpeg
    cloc

    # gui
    vlc
    monero-cli
    qbittorrent
    rsibreak
    (ghidra.withExtensions (p: with p; [
      wasm
    ]))

  ] ++ (with pkgs.kdePackages; [
    kcalc
    kcharselect
    kclock
    kcolorchooser
    ksystemlog
  ]);

  programs.obs-studio = {
    enable = true;
    # plugins required to make obs work on wayland
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };

  programs.git = {
    enable = true;
    settings.user.name = "Aled Lorans";
    settings.user.email = "143277280+alorans@users.noreply.github.com";
  };

  # install direnv + nix-direnv
  # to integrate with an existing flake.nix: echo "use flake" >> .envrc && direnv allow
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = false; # we write our own below
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      # stop the massive export line from nix-direnv
      # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
      initExtra = ''
        export DIRENV_LOG_FORMAT="$(printf "\033[2mdirenv: %%s\033[0m")"
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
        _direnv_hook() {
          eval "$(${pkgs.direnv}/bin/direnv export bash 2> >(egrep -v -e '^....direnv: export' >&2))"
        };
      '';
    };
  };

  programs.vscodium = {
    enable = true;

    package = (pkgs.unstable.vscodium.overrideAttrs (oldAttrs: {
      # must disable builtin html language features for superhtml
      postFixup = (oldAttrs.postFixup or "") + ''
        wrapProgram $out/bin/codium \
          --add-flags "--disable-extension vscode.html-language-features"
      '';
    }));

    profiles.default = {
      userSettings = {
        "window.autoDetectColorScheme" = true;
        "workbench.preferredDarkColorTheme" = "Default Dark";
        "workbench.preferredLightColorTheme" = "Default Light";
        "zig.path" = "zig";
        "zig.zls.path" = "zls";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
      };

      extensions = with pkgs.open-vsx-release; [
        ms-python.python
        kermanx.p2p-live-share
        alefragnani.bookmarks
        ziglang.vscode-zig
        mkhl.direnv
        jnoortheen.nix-ide
        loriscro.super
        ms-vscode.wasm-wasi-core
        ritwickdey.liveserver
        vscodevim.vim
        pucelle.run-on-save
        llvm-vs-code-extensions.vscode-clangd
      ];
    };
  };

  # set rsibreak configuration
  # this is for 20-20-20 (every 20 minutes, look 20 feet away for 20 seconds)
  xdg.configFile."rsibreakrc".text = ''
    [General]
    AutoStart=false

    [General Settings]
    BigDuration=1
    BigEnabled=false
    BigInterval=1
    BigThreshold=10
    TinyDuration=20
    TinyEnabled=true
    TinyInterval=20
    TinyThreshold=40
    DisableAccel=true
    Effect=0
    Graylevel=100
    HideLockButton=true
    HideMinimizeButton=true
    HidePostponeButton=true
    Patience=30
    PostponeBreakDuration=5
    SlideInterval=10
    SuppressIfPresenting=false
    UseNoIdleTimer=true
    UsePlasmaReadOnly=true

    [Notification Messages]
    dont_show_welcome_again_for_001=false

    [Popup Settings]
    UseFlash=true
    UsePopup=false
  '';

  xdg.configFile."autostart/rsibreak.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=RSIBreak
    Exec=${pkgs.rsibreak}/bin/rsibreak
  '';

  # KDE plasma settings
  programs.plasma = {
    enable = true;

    workspace = {
      # Solid black wallpaper R,G,B(,A)
      wallpaperPlainColor = "0,0,0";
    };

    kwin = {
      virtualDesktops = {
        number = 3;
        rows = 1;
        names = [ "Desktop 1" "Desktop 2" "Desktop 3" ];
      };

      effects.desktopSwitching = {
        animation = "off";
      };
    };
  };
}
