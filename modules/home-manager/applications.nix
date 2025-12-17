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
    
    # Video downloaders
    yt-dlp  # Actively maintained youtube-dl fork (recommended)
    # youtube-dl  # Original youtube downloader (outdated, use yt-dlp instead)

    # ===== Productivity =====
    obsidian
    standardnotes  # Privacy-focused note-taking
    libreoffice-fresh  # Office suite
    thunderbird  # Email client
    # logseq  # Alternative knowledge base
    
    # Notion wrapper using Chromium in app mode (avoids Electron issues)
    (pkgs.writeShellScriptBin "notion" ''
      exec ${pkgs.chromium}/bin/chromium \
        --app="https://www.notion.so" \
        --class="notion" \
        --user-data-dir="$HOME/.config/notion-chromium" \
        --enable-features=UseOzonePlatform,VaapiVideoDecoder \
        --ozone-platform=x11 \
        --use-gl=egl \
        "$@"
    '')
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
    kdePackages.partitionmanager  # KDE disk partitioning and formatting tool
    gnome-disk-utility  # GNOME Disks - simpler disk formatting tool
    
    # Screen Recording Tools
    kooha  # Simple screen recorder with native Wayland support
    obs-studio  # Professional screen recorder with Wayland support
    gpu-screen-recorder  # GPU-accelerated recording for NVIDIA
    gpu-screen-recorder-gtk  # GTK frontend for gpu-screen-recorder

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

    # ===== E-book Readers =====
    calibre  # Full-featured e-book manager with reader
    foliate  # Modern, lightweight EPUB reader
    zathura  # Minimalist document viewer with EPUB support
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

  # Desktop entry for Notion
  xdg.desktopEntries.notion = {
    name = "Notion";
    comment = "The AI workspace that works for you";
    exec = "notion";
    icon = "notion";
    terminal = false;
    type = "Application";
    categories = [ "Office" "Network" "WebBrowser" ];
    mimeType = [ "x-scheme-handler/notion" ];
    startupNotify = true;
  };

  # Browser configurations moved to browsers.nix

  # Environment variables for better Electron app support
  home.sessionVariables = {
    # NVIDIA GPU configuration is handled in gpu-acceleration.nix
    # These are general Electron app settings
    
    # Enable hardware acceleration for Electron apps
    ELECTRON_IS_DEV = "0";
    ELECTRON_TRASH = "gio";
    
    # Chrome/Electron flags for better compatibility
    CHROME_EXECUTABLE = "chromium";
    
    # Enable GPU acceleration for better desktop performance
    LIBGL_DRI3_ENABLE = "1";
    __GL_SYNC_TO_VBLANK = "1";
    
    # Electron/Chrome GPU settings for NVIDIA compatibility
    # These help prevent blank screens in Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";  # Auto-detect best platform
    DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1 = "1";  # Prevent GPU switching issues
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";  # Keep shader cache for performance
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
