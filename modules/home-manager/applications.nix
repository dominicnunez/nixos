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
    
    # Notion with custom wrapper for AMD GPU compatibility
    # Using simplified flags to avoid internal errors
    (pkgs.writeShellScriptBin "notion" ''
      # Force software rendering to avoid AMD GPU issues
      export LIBGL_ALWAYS_SOFTWARE=1
      export ELECTRON_DISABLE_GPU=1
      
      # Launch notion-app-enhanced with minimal GPU workarounds
      # Reduced flags to avoid "callback called more than once" errors
      exec ${pkgs.notion-app-enhanced}/bin/notion-app-enhanced \
        --no-sandbox \
        --disable-gpu \
        --use-gl=swiftshader \
        "$@"
    '')
    
    # Install notion-app-enhanced (only Linux-compatible Notion package)
    notion-app-enhanced  # Notion with enhancer for Linux
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
    # gemini-cli  # Google Gemini AI agent for terminal - temporarily disabled due to hash mismatch

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
  # Comprehensive fix for Notion blank window issue on NixOS/Linux
  # Provides multiple solutions for AMD GPU compatibility issues
  
  # Desktop entry for standard Notion (using our wrapper)
  home.file.".local/share/applications/notion-fixed.desktop".text = ''
    [Desktop Entry]
    Name=Notion (Fixed)
    Comment=Write, plan, collaborate, and get organized (GPU workaround)
    GenericName=Productivity
    Exec=notion %U
    Icon=notion-app-enhanced
    Type=Application
    StartupNotify=true
    StartupWMClass=Notion
    Categories=Office;
    MimeType=x-scheme-handler/notion;
    X-GNOME-SingleWindow=true
  '';
  
  # Desktop entry for Notion Enhanced (alternate launcher)
  home.file.".local/share/applications/notion-enhanced-fixed.desktop".text = ''
    [Desktop Entry]
    Name=Notion Enhanced (Direct)
    Comment=Write, plan, collaborate, and get organized (direct launcher with simplified GPU fix)
    GenericName=Productivity
    Exec=env LIBGL_ALWAYS_SOFTWARE=1 ELECTRON_DISABLE_GPU=1 notion-app-enhanced --no-sandbox --disable-gpu --use-gl=swiftshader %U
    Icon=notion-app-enhanced
    Type=Application
    StartupNotify=true
    StartupWMClass=Notion
    Categories=Office;
    MimeType=x-scheme-handler/notion;
    X-GNOME-SingleWindow=true
  '';

  # Alternative direct launcher script
  home.file.".local/bin/notion-launcher".text = ''
    #!/usr/bin/env bash
    # Direct launcher for Notion with comprehensive GPU workarounds
    
    # Set all necessary environment variables
    export LIBGL_ALWAYS_SOFTWARE=1
    export ELECTRON_DISABLE_GPU=1
    export ELECTRON_NO_SANDBOX=1
    export MESA_LOADER_DRIVER_OVERRIDE=radeonsi
    export __GLX_VENDOR_LIBRARY_NAME=mesa
    
    # Try notion (our wrapper) first, fallback to notion-app-enhanced
    if command -v notion >/dev/null 2>&1; then
      exec notion "$@"
    elif command -v notion-app-enhanced >/dev/null 2>&1; then
      exec notion-app-enhanced \
        --no-sandbox \
        --disable-gpu \
        --use-gl=swiftshader \
        "$@"
    else
      echo "Error: No Notion installation found"
      exit 1
    fi
  '';
  
  home.file.".local/bin/notion-launcher".executable = true;
  
  # Debug version of Notion launcher to test different configurations
  home.file.".local/bin/notion-debug".text = ''
    #!/usr/bin/env bash
    echo "Notion Debug Launcher"
    echo "====================="
    echo "Testing different GPU configurations..."
    echo ""
    echo "Press 1 for software rendering (safest)"
    echo "Press 2 for hardware acceleration (might cause blank screen)"
    echo "Press 3 for hybrid mode"
    read -n1 -p "Choice: " choice
    echo ""
    
    case $choice in
      1)
        echo "Starting with software rendering..."
        export LIBGL_ALWAYS_SOFTWARE=1
        export ELECTRON_DISABLE_GPU=1
        exec notion-app-enhanced --no-sandbox --disable-gpu --use-gl=swiftshader "$@"
        ;;
      2)
        echo "Starting with hardware acceleration..."
        exec notion-app-enhanced --no-sandbox "$@"
        ;;
      3)
        echo "Starting with hybrid mode..."
        exec notion-app-enhanced --no-sandbox --disable-gpu-compositing "$@"
        ;;
      *)
        echo "Invalid choice"
        exit 1
        ;;
    esac
  '';
  
  home.file.".local/bin/notion-debug".executable = true;

  # Environment variables for Electron apps (including Notion)
  home.sessionVariables = {
    # Fix Electron apps on AMD GPUs
    LIBVA_DRIVER_NAME = "radeonsi";
    
    # Additional Mesa/OpenGL settings for AMD
    MESA_LOADER_DRIVER_OVERRIDE = "radeonsi";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    
    # Electron app optimizations
    ELECTRON_IS_DEV = "0";
    ELECTRON_ENABLE_LOGGING = "1";
    ELECTRON_TRASH = "gio";
    
    # Chrome/Electron flags for better compatibility
    CHROME_EXECUTABLE = "chromium";
    
    # Disable GPU features that cause issues
    ELECTRON_DISABLE_GPU = "1";
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
