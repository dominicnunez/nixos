# modules/home-manager/applications.nix - User desktop applications
{ config, pkgs, lib, ... }:

{
  # Desktop applications for the user
  home.packages = with pkgs; [
    # ===== Browsers =====
    # Firefox is managed at system level with programs.firefox.enable
    brave
    google-chrome
    chromium
    
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
    
    # ===== Gaming Launchers & Tools =====
    lutris
    heroic
    bottles
    protontricks
    
    # ===== Gaming Utilities =====
    jstest-gtk  # Joystick testing
    antimicrox  # Controller mapping
    goverlay  # MangoHud GUI
    r2modman  # Unity mod manager
    
    # ===== Emulators =====
    retroarch
    dolphin-emu
    # pcsx2  # PlayStation 2 emulator
    # rpcs3  # PlayStation 3 emulator
    # yuzu  # Nintendo Switch emulator
    
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
  
  # Firefox (user-specific settings)
  # Note: Firefox is installed system-wide, but we can configure user settings
  programs.firefox = {
    enable = false;  # Already enabled at system level
    
    # User profiles and settings would go here if we were managing Firefox via Home Manager
    # profiles = {
    #   default = {
    #     settings = {
    #       "browser.startup.homepage" = "https://start.duckduckgo.com";
    #       "privacy.trackingprotection.enabled" = true;
    #     };
    #   };
    # };
  };
  
  # Chromium configuration
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # Dark Reader
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      # Vimium
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
    ];
  };
  
  # Discord configuration (via Home Manager when available)
  # Currently just installed as a package
  
  # Spotify configuration (if Home Manager module becomes available)
  # Currently just installed as a package
  
  # Desktop file associations
  xdg = {
    enable = true;
    
    # MIME type associations
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = ["firefox.desktop"];
        "text/xml" = ["firefox.desktop"];
        "application/pdf" = ["firefox.desktop"];
        "application/x-extension-htm" = ["firefox.desktop"];
        "application/x-extension-html" = ["firefox.desktop"];
        "application/x-extension-shtml" = ["firefox.desktop"];
        "application/x-extension-xhtml" = ["firefox.desktop"];
        "application/x-extension-xht" = ["firefox.desktop"];
        "application/xhtml+xml" = ["firefox.desktop"];
        
        "image/jpeg" = ["org.kde.gwenview.desktop"];
        "image/png" = ["org.kde.gwenview.desktop"];
        "image/gif" = ["org.kde.gwenview.desktop"];
        
        "video/mp4" = ["vlc.desktop"];
        "video/x-matroska" = ["vlc.desktop"];
        "video/webm" = ["vlc.desktop"];
        "audio/mp3" = ["vlc.desktop"];
        "audio/flac" = ["vlc.desktop"];
        
        "text/plain" = ["org.kde.kate.desktop" "code.desktop"];
        "text/x-python" = ["code.desktop"];
        "text/x-shellscript" = ["code.desktop"];
        "application/x-yaml" = ["code.desktop"];
        "application/json" = ["code.desktop"];
        
        "inode/directory" = ["org.kde.dolphin.desktop"];
        
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/discord" = ["discord.desktop"];
        "x-scheme-handler/spotify" = ["spotify.desktop"];
      };
    };
    
    # Desktop entries
    desktopEntries = {
      # Custom desktop entries can be added here
      # Example:
      # "my-app" = {
      #   name = "My Application";
      #   exec = "my-app %F";
      #   icon = "my-app";
      #   comment = "My custom application";
      #   categories = ["Utility"];
      # };
    };
  };
}