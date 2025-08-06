# modules/home-manager/applications.nix - User desktop applications
{ config, pkgs, lib, ... }:

{
  # Desktop applications for the user
  home.packages = with pkgs; [
    # ===== Browsers =====
    # Browsers are configured in browsers.nix
    
    # ===== Communication =====
    discord
    # thunderbird  # Uncomment when ready to use
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
    copyq  # Clipboard manager
    # peek  # GIF recorder
    # ksnip  # Alternative screenshot tool
    
    # ===== Gaming =====
    # Gaming packages moved to gaming.nix
    
    # ===== File Management =====
    # dolphin  # KDE file manager (if not using KDE)
    # nautilus  # GNOME file manager
    # thunar  # XFCE file manager
    # ranger  # Terminal file manager (TUI)
    
    # ===== Additional Tools =====
    # gimp  # Image editor
    # inkscape  # Vector graphics
    # krita  # Digital painting
    # blender  # 3D modeling
    # freecad  # CAD software
  ];
  
  # Application-specific configurations
  
  # VS Code configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # Default profile with settings and extensions
    profiles = {
      default = {
        # User settings
        userSettings = {
      "editor.fontSize" = 13;
      "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', monospace";
      "editor.fontLigatures" = true;
      "editor.lineHeight" = 22;
      "editor.rulers" = [80 120];
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "selection";
      "editor.suggestSelection" = "first";
      "editor.acceptSuggestionOnCommitCharacter" = false;
      
      "workbench.colorTheme" = "Dracula";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";
      
      "terminal.integrated.fontSize" = 13;
      "terminal.integrated.fontFamily" = "'JetBrains Mono'";
      "terminal.integrated.defaultProfile.linux" = "bash";
      
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "git.autofetch" = true;
      
      "extensions.ignoreRecommendations" = false;
      "telemetry.telemetryLevel" = "off";
      
      # Language-specific settings
      "[python]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "ms-python.black-formatter";
      };
      "[javascript]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[rust]" = {
        "editor.formatOnSave" = true;
      };
      "[nix]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
    };
    
        # Extensions to install
        extensions = with pkgs.vscode-extensions; [
      # Themes
      dracula-theme.theme-dracula
      pkief.material-icon-theme
      
      # General
      editorconfig.editorconfig
      streetsidesoftware.code-spell-checker
      usernamehw.errorlens
      gruntfuggly.todo-tree
      
      # Git
      eamodio.gitlens
      mhutchie.git-graph
      donjayamanne.githistory
      
      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      
      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.black-formatter
      ms-python.isort
      
      # JavaScript/TypeScript
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      
      # Rust
      rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      
      # Go
      golang.go
      
      # Docker/Kubernetes
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools
      
      # YAML/JSON
      redhat.vscode-yaml
      
      # Markdown
      yzhang.markdown-all-in-one
      bierner.markdown-mermaid
      
      # Remote Development
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
        ];
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