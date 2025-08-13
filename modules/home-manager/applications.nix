# modules/home-manager/applications.nix - User desktop applications
{ config, pkgs, lib, ... }:

{
  # Desktop applications for the user
  home.packages = with pkgs; [
    # ===== Browsers =====
    # Browsers are configured in browsers.nix

    # ===== Communication =====
    discord
    # element-desktop  # Matrix client
    # signal-desktop  # Signal messenger

    # ===== Media =====
    spotify
    vlc
    # mpv  # Alternative video player
    # audacity  # Audio editor
    # obs-studio  # Streaming/recording

    # ===== Productivity =====
    obsidian
    libreoffice-fresh  # Office suite
    # logseq  # Alternative knowledge base
    # notion-app-enhanced  # Note-taking
    # zettlr  # Markdown editor

    # ===== Development IDEs =====
    vscode
    # vscodium  # Open source VS Code
    # jetbrains.idea-community  # IntelliJ IDEA
    # sublime4  # Sublime Text
    # zed-editor  # Modern collaborative editor

    # ===== Password Management =====
    enpass
    # bitwarden  # Alternative password manager
    # keepassxc  # Offline password manager

    # ===== System Utilities =====
    flameshot  # Screenshot tool
    # copyq  # Clipboard manager
    peek  # GIF recorder
    ksnip  # Alternative screenshot tool

    # ===== Gaming =====
    # Gaming packages moved to gaming.nix

    # ===== Additional Tools =====
    gimp  # Image editor
    inkscape  # Vector graphics
    krita  # Digital painting
    blender  # 3D modeling
    freecad  # CAD software
  ];

  # Application-specific configurations

  # VS Code configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # Allow VS Code to manage extensions in a mutable directory
    mutableExtensionsDir = true;

    # Note: userSettings removed to allow manual management of settings.json
    # The settings.json file at ~/.config/Code/User/settings.json
    # is now managed manually by the user, not by NixOS

    # Configuration profiles
    profiles = {
      default = {
        # Extensions to install (moved to new location per deprecation warning)
        extensions = with pkgs.vscode-extensions; [
          # Themes and Icons
          dracula-theme.theme-dracula
          pkief.material-icon-theme
          vscode-icons-team.vscode-icons

          # General Development Tools
          editorconfig.editorconfig
          streetsidesoftware.code-spell-checker
          usernamehw.errorlens
          gruntfuggly.todo-tree

          # Git Integration
          eamodio.gitlens
          mhutchie.git-graph
          donjayamanne.githistory
          github.vscode-pull-request-github

          # Nix
          jnoortheen.nix-ide

          # Python
          ms-python.python
          ms-python.vscode-pylance
          ms-python.black-formatter
          ms-python.isort
          ms-python.debugpy

          # JavaScript/TypeScript/Web
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode
          bradlc.vscode-tailwindcss
          stylelint.vscode-stylelint

          # Rust
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          fill-labs.dependi

          # Go
          golang.go

          # Docker/Kubernetes/Containers
          ms-azuretools.vscode-docker
          ms-kubernetes-tools.vscode-kubernetes-tools
          ms-vscode-remote.remote-containers

          # YAML/JSON/Data Formats
          redhat.vscode-yaml

          # Markdown
          yzhang.markdown-all-in-one
          bierner.markdown-mermaid
          davidanson.vscode-markdownlint

          # Remote Development
          # ms-vscode-remote.remote-ssh  # Uncomment if needed

          # Microsoft IntelliSense
          visualstudioexptteam.vscodeintellicode
          visualstudioexptteam.intellicode-api-usage-examples

          # API Testing
          # postman.postman-for-vscode  # Not commonly available in nixpkgs
        ] ++ (
          # Extensions not available in nixpkgs but can be fetched from marketplace
          pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # Note: Claude Code extension is already added via overlay in flake.nix
            # Add any other marketplace extensions here if needed
          ]
        );
      };
    };
  };

  # Browser configurations moved to browsers.nix

  # ===== Media Application Settings =====

  # Spotify configuration
  # Note: Spotify doesn't have a Home Manager module, but we can set preferences
  home.file.".config/spotify-tui/config.yml".text = ''
    # Spotify TUI configuration (if you use spotify-tui)
    theme:
      active: Cyan
      banner: Green
      error_border: Red
      error_text: LightRed
      hint: Yellow
      hovered: Magenta
      inactive: Gray
      playbar_background: Black
      playbar_progress: Green
      playbar_text: White
      selected: LightCyan
      text: White
    behavior:
      seek_milliseconds: 5000
      volume_increment: 5
      tick_rate_milliseconds: 250
  '';

  # VLC configuration
  home.file.".config/vlc/vlcrc".text = ''
    # VLC media player preferences
    [core]
    # Interface settings
    intf=qt
    qt-minimal-view=0

    # Video settings
    video-title-show=1
    video-title-timeout=2000
    deinterlace=1
    deinterlace-mode=yadif

    # Audio settings
    audio-language=en
    volume-save=1

    # Subtitle settings
    sub-language=en
    sub-autodetect-file=1

    # Performance
    ffmpeg-hw=1
    avcodec-hw=any

    # Network
    http-reconnect=1
  '';

  # Discord configuration
  home.file.".config/discord/settings.json".text = builtins.toJSON {
    # Discord settings (basic, as most are stored server-side)
    SKIP_HOST_UPDATE = true;
    MINIMIZE_TO_TRAY = true;
    OPEN_ON_STARTUP = false;
  };

  # ===== Productivity Application Settings =====

  # Obsidian configuration
  # Note: Obsidian stores most settings in the vault, but we can set app preferences
  home.file.".config/obsidian/obsidian.json".text = builtins.toJSON {
    vaults = {
      # Add your vault paths here if you want them pre-configured
      # "vault-id" = {
      #   path = "/home/aural/Documents/ObsidianVault";
      #   open = true;
      # };
    };
    # App preferences
    theme = "obsidian";
    showRibbon = true;
    showLeftSidebar = true;
    showRightSidebar = true;
    alwaysUpdateLinks = true;
  };

  # LibreOffice configuration
  # Note: LibreOffice stores config in a complex structure, but we can set some defaults
  home.file.".config/libreoffice/4/user/registrymodifications.xcu".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <!-- Save in ODF format by default -->
      <item oor:path="/org.openoffice.Office.Common/Filter/Microsoft/Export">
        <prop oor:name="SaveAlwaysAllowed" oor:op="fuse">
          <value>false</value>
        </prop>
      </item>
      <!-- Default font -->
      <item oor:path="/org.openoffice.Office.Writer/DefaultFont">
        <prop oor:name="Standard" oor:op="fuse">
          <value>Liberation Sans;12</value>
        </prop>
      </item>
      <!-- Auto-save every 10 minutes -->
      <item oor:path="/org.openoffice.Office.Common/Save/Document">
        <prop oor:name="AutoSave" oor:op="fuse">
          <value>true</value>
        </prop>
        <prop oor:name="AutoSaveTimeIntervall" oor:op="fuse">
          <value>10</value>
        </prop>
      </item>
    </oor:items>
  '';

  # Thunderbird configuration (if you decide to use it)
  # home.file.".thunderbird/profiles.ini".text = ''
  #   [Profile0]
  #   Name=default
  #   IsRelative=1
  #   Path=default.profile
  #   Default=1
  # '';

  # XDG configuration moved to xdg.nix
}
