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
    standardnotes  # Privacy-focused note-taking
    libreoffice-fresh  # Office suite
    # logseq  # Alternative knowledge base
    notion-app-enhanced  # Note-taking (Linux-compatible version with enhancer)
    # zettlr  # Markdown editor

    # ===== Development IDEs =====
    # vscode configured via programs.vscode module below
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

    # ===== Gaming =====
    # Gaming packages moved to gaming.nix

    # ===== AI & Terminal Tools =====
    gemini-cli  # Google Gemini AI agent for terminal

    # ===== Additional Tools =====
    gimp  # Image editor
    inkscape  # Vector graphics
    krita  # Digital painting
    blender  # 3D modeling
    freecad  # CAD software
  ];

  # Application-specific configurations

  # VS Code configuration - Minimal setup with full extension management freedom
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # Allow VS Code to manage extensions in a mutable directory
    mutableExtensionsDir = true;

    # Note: userSettings removed to allow manual management of settings.json
    # The settings.json file at ~/.config/Code/User/settings.json
    # is now managed manually by the user, not by NixOS

    # No extensions managed by Nix - VS Code has full control
    # All extensions should be installed through VS Code's extension marketplace
    # This allows for:
    # - Automatic updates
    # - Easy installation/removal
    # - Access to the full marketplace
    # - User preferences for extension versions
  };

  # Browser configurations moved to browsers.nix

  # ===== Notion Configuration =====
  # Fix for Notion blank window issue on NixOS/Linux using notion-app-enhanced
  home.file.".local/share/applications/notion-app-enhanced.desktop".text = ''
    [Desktop Entry]
    Name=Notion Enhanced
    Comment=Write, plan, collaborate, and get organized (with enhancer)
    GenericName=Productivity
    Exec=notion-app-enhanced --no-sandbox --disable-gpu-sandbox --disable-dev-shm-usage --disable-software-rasterizer --disable-features=VizDisplayCompositor %U
    Icon=notion-app-enhanced
    Type=Application
    StartupNotify=true
    StartupWMClass=Notion
    Categories=Office;
    MimeType=x-scheme-handler/notion;
    X-GNOME-SingleWindow=true
  '';

  # Environment variables for Electron apps (including Notion)
  home.sessionVariables = {
    # Fix Electron apps on AMD GPUs
    LIBVA_DRIVER_NAME = "radeonsi";
    
    # Electron app optimizations
    ELECTRON_IS_DEV = "0";
    ELECTRON_ENABLE_LOGGING = "1";
    
    # Chrome/Electron flags for better compatibility
    CHROME_EXECUTABLE = "chromium";
  };

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
