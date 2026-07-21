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
    python3
    unstable.zig
    unstable.zls
    unstable.yt-dlp
    clang-tools
    kdiff3
    ffmpeg
    cloc
    nushell
    monero-cli

    # gui
    vlc
    tor-browser
    qbittorrent
    rsibreak
    signal-desktop
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
    # settings.user.name = "Aled Lorans";
    # settings.user.email = "143277280+alorans@users.noreply.github.com";
  };

  # github integration
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  # https://hugosum.com/blog/customizing-firefox-with-nix-and-home-manager
  programs.firefox = {
    enable = true;

    # KDE Plasma integration
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    configPath = ".mozilla/firefox";

    profiles."default" = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # use userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # KDE integration
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        # hide new sidebar and bookmarks bar
        "sidebar.revamp" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        # new tab and new window are blank
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        # disable firefox pocket
        "extensions.pocket.enabled" = false;
        "browser.toolbarbuttons.introduced.pocket-button" = false;
        # disable firefox accounts
        "identity.fxaccounts.enabled" = false;
        # don't warn on quit
        "browser.warnOnQuit" = false;
        # restore previous session on startup
        "browser.startup.page" = 3;
        # login should be handled by a proper password manager
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "browser.formfill.enable" = false;
      };

      # Hide horizontal tabs ui
      # Hide all sidebar titles
      userChrome = ''
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items { opacity: 0; pointer-events: none; }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar { visibility: collapse !important; }
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar .titlebar-spacer { border-inline-end: none; }
        #sidebar-header { display: none; }
      '';
    };

    # Enable BetterFox
    betterfox = {
      enable = true;
      profiles."default" = {
        enableAllSections = true;
      };
    };

    # Extensions
    policies = {
      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        # "*".installation_mode = "blocked";
        # turn on if you want to block the installation of extra extensions

        "uBlock0@raymondhill.net" = {
          default_area      = "navbar";
          install_url       = moz "ublock-origin";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        # noscript
        "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          default_area      = "navbar";
          install_url       = moz "noscript";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        # KDE Plasma integration
        "plasma-browser-integration@kde.org" = {
          install_url       = moz "plasma-integration";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        # tree style tab
        # TODO: use an overlay or something to add TST config CSS for firefox colors, light mode, and keybindings
        # TODO: also I heard that some of these can be installed from the NUR. Look into that.
        "treestyletab@piro.sakura.ne.jp" = {
          install_url       = moz "tree-style-tab";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };

        # unhook ng
        "@unhookng" = {
          install_url       = moz "unhook-ng";
          installation_mode = "force_installed";
          updates_disabled  = true;
        };
      };
    };
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
    # this makes it so pressing up arrow shows commands in your history that start with whatever you've typed already
    readline = {
      enable = true;
      bindings = {
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
      };
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
        "zig.path" = "zig"; # use system zig
        "zig.zls.path" = "zls";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "vim.surround" = true;
        "vim.leader" = "<space>";
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "<leader>" "r" ];
            commands = [ "editor.action.rename" ];
          }
          {
            before = [ "<leader>" "g" ];
            commands = [ "editor.action.revealDefinition" ];
          }
        ];
      };
      keybindings = [
        {
          # turn off vim with a keybinding
          "key" = "ctrl+alt+v";
          "command" = "toggleVim";
          # by the way, with vim on, ctrl+i and ctrl+o navigate your jump history
        }
      ];

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
        ms-vscode.cmake-tools
      ];
    };
  };

  # this enables custom config and also system clipboard integration
  programs.vim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.vim-surround
    ];
    extraConfig = ''
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set linebreak
      set breakindent
      set breakindentopt=shift:2
      syntax on
    '';
  };

  # set rsibreak configuration
  # this is for 20-20-20 (every 20 minutes, look 20 feet away for 20 seconds)
  xdg.configFile."rsibreakrc".text = ''
    [General]
    AutoStart=false

    [General Settings]
    BigDuration=1
    BigEnabled=false
    BigInterval=60
    BigThreshold=5
    DisableAccel=false
    Effect=0
    ExpandImageToFullScreen=true
    Graylevel=80
    HideLockButton=true
    HideMinimizeButton=true
    HidePostponeButton=true
    ImageFolder=${config.home.homeDirectory}
    Patience=30
    PostponeBreakDuration=5
    SearchRecursiveCheck=false
    ShowSmallImagesCheck=true
    SlideInterval=10
    SuppressIfPresenting=true
    TinyDuration=20
    TinyEnabled=true
    TinyInterval=20
    TinyThreshold=300
    UseNoIdleTimer=false
    UsePlasmaReadOnly=true

    [Notification Messages]
    dont_show_welcome_again_for_001=false

    [Popup Settings]
    UseFlash=false
    UsePopup=false
  '';
  
  # handle rsibreak autostart
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
