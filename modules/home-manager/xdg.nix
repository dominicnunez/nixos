# modules/home-manager/xdg.nix - XDG configuration and file associations
{ config, pkgs, lib, ... }:

{
  # Enable XDG base directories
  xdg = {
    enable = true;
    
    # XDG user directories
    userDirs = {
      enable = true;
      createDirectories = true;
      
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
      
      # Custom directories
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
        XDG_GAMES_DIR = "$HOME/Games";
        XDG_PROJECTS_DIR = "$HOME/Projects";
        XDG_WALLPAPERS_DIR = "$HOME/Pictures/Wallpapers";
      };
    };
    
    # Consolidated MIME type associations
    mimeApps = {
      enable = true;
      
      defaultApplications = {
        # ===== Web Content =====
        "text/html" = ["brave-browser.desktop"];
        "x-scheme-handler/http" = ["brave-browser.desktop"];
        "x-scheme-handler/https" = ["brave-browser.desktop"];
        "x-scheme-handler/ftp" = ["brave-browser.desktop"];
        "x-scheme-handler/chrome" = ["brave-browser.desktop"];
        "x-scheme-handler/about" = ["brave-browser.desktop"];
        "x-scheme-handler/unknown" = ["brave-browser.desktop"];
        "application/x-extension-htm" = ["brave-browser.desktop"];
        "application/x-extension-html" = ["brave-browser.desktop"];
        "application/x-extension-shtml" = ["brave-browser.desktop"];
        "application/xhtml+xml" = ["brave-browser.desktop"];
        "application/x-extension-xhtml" = ["brave-browser.desktop"];
        "application/x-extension-xht" = ["brave-browser.desktop"];
        
        # ===== Images =====
        "image/jpeg" = ["org.kde.gwenview.desktop" "gimp.desktop"];
        "image/png" = ["org.kde.gwenview.desktop" "gimp.desktop"];
        "image/gif" = ["org.kde.gwenview.desktop" "gimp.desktop"];
        "image/webp" = ["org.kde.gwenview.desktop" "gimp.desktop"];
        "image/bmp" = ["org.kde.gwenview.desktop" "gimp.desktop"];
        "image/svg+xml" = ["inkscape.desktop" "org.kde.gwenview.desktop"];
        "image/tiff" = ["org.kde.gwenview.desktop" "gimp.desktop"];
        
        # ===== Video =====
        "video/mp4" = ["vlc.desktop" "mpv.desktop"];
        "video/x-matroska" = ["vlc.desktop" "mpv.desktop"];
        "video/webm" = ["vlc.desktop" "mpv.desktop"];
        "video/avi" = ["vlc.desktop" "mpv.desktop"];
        "video/quicktime" = ["vlc.desktop" "mpv.desktop"];
        "video/x-msvideo" = ["vlc.desktop" "mpv.desktop"];
        "video/x-flv" = ["vlc.desktop" "mpv.desktop"];
        
        # ===== Audio =====
        "audio/mp3" = ["vlc.desktop" "spotify.desktop"];
        "audio/mpeg" = ["vlc.desktop" "spotify.desktop"];
        "audio/flac" = ["vlc.desktop" "audacity.desktop"];
        "audio/ogg" = ["vlc.desktop" "audacity.desktop"];
        "audio/wav" = ["vlc.desktop" "audacity.desktop"];
        "audio/x-wav" = ["vlc.desktop" "audacity.desktop"];
        "audio/aac" = ["vlc.desktop"];
        
        # ===== Text/Code =====
        "text/plain" = ["code.desktop" "org.kde.kate.desktop" "nvim.desktop"];
        "text/x-python" = ["code.desktop" "nvim.desktop"];
        "text/x-shellscript" = ["code.desktop" "nvim.desktop"];
        "text/x-c" = ["code.desktop" "nvim.desktop"];
        "text/x-c++" = ["code.desktop" "nvim.desktop"];
        "text/x-java" = ["code.desktop" "nvim.desktop"];
        "text/x-go" = ["code.desktop" "nvim.desktop"];
        "text/x-rust" = ["code.desktop" "nvim.desktop"];
        "text/markdown" = ["code.desktop" "obsidian.desktop" "nvim.desktop"];
        "text/x-markdown" = ["code.desktop" "obsidian.desktop" "nvim.desktop"];
        
        # ===== Data Formats =====
        "application/json" = ["code.desktop" "nvim.desktop"];
        "application/xml" = ["code.desktop" "nvim.desktop"];
        "application/x-yaml" = ["code.desktop" "nvim.desktop"];
        "application/toml" = ["code.desktop" "nvim.desktop"];
        
        # ===== Documents =====
        "application/pdf" = ["org.kde.okular.desktop" "brave-browser.desktop"];
        "application/vnd.oasis.opendocument.text" = ["libreoffice-writer.desktop"];
        "application/vnd.oasis.opendocument.spreadsheet" = ["libreoffice-calc.desktop"];
        "application/vnd.oasis.opendocument.presentation" = ["libreoffice-impress.desktop"];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["libreoffice-writer.desktop"];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["libreoffice-calc.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["libreoffice-impress.desktop"];
        "application/msword" = ["libreoffice-writer.desktop"];
        "application/vnd.ms-excel" = ["libreoffice-calc.desktop"];
        "application/vnd.ms-powerpoint" = ["libreoffice-impress.desktop"];
        
        # ===== Archives =====
        "application/zip" = ["org.kde.ark.desktop"];
        "application/x-tar" = ["org.kde.ark.desktop"];
        "application/x-gzip" = ["org.kde.ark.desktop"];
        "application/x-bzip2" = ["org.kde.ark.desktop"];
        "application/x-7z-compressed" = ["org.kde.ark.desktop"];
        "application/x-rar" = ["org.kde.ark.desktop"];
        
        # ===== Directories =====
        "inode/directory" = ["org.kde.dolphin.desktop" "thunar.desktop"];
        
        # ===== Application Protocols =====
        "x-scheme-handler/discord" = ["discord.desktop"];
        "x-scheme-handler/spotify" = ["spotify.desktop"];
        "x-scheme-handler/obsidian" = ["obsidian.desktop"];
        "x-scheme-handler/steam" = ["steam.desktop"];
        "x-scheme-handler/lutris" = ["lutris.desktop"];
        "x-scheme-handler/heroic" = ["heroic.desktop"];
        "x-scheme-handler/mailto" = ["thunderbird.desktop"];
        "x-scheme-handler/vscode" = ["code-url-handler.desktop"];
        "x-scheme-handler/terminal" = ["org.kde.konsole.desktop" "alacritty.desktop"];
      };
      
      # Associations to add (won't replace existing)
      associations.added = {
        "application/x-shellscript" = ["code.desktop"];
        "text/x-makefile" = ["code.desktop"];
        "text/x-cmake" = ["code.desktop"];
        "text/x-dockerfile" = ["code.desktop"];
      };
      
      # Associations to remove
      associations.removed = {
        # Remove any unwanted associations here
        # "text/html" = ["firefox.desktop"];
      };
    };
    
    # Portal configuration for sandboxed apps
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
      
      config = {
        common = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        
        kde = {
          default = ["kde"];
          "org.freedesktop.impl.portal.FileChooser" = ["kde"];
        };
      };
    };
    
    # Desktop entries for custom applications
    desktopEntries = {
      # Neovim desktop entry
      nvim = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = "kitty nvim %F";
        terminal = false;
        icon = "nvim";
        comment = "Edit text files in Neovim";
        categories = ["Utility" "TextEditor"];
        mimeType = ["text/plain" "text/x-python" "text/x-shellscript"];
      };
      
      # Custom game launcher
      game-launcher = lib.mkIf (builtins.pathExists "/home/aural/Scripts/game-launcher.sh") {
        name = "Game Launcher";
        exec = "/home/aural/Scripts/game-launcher.sh";
        icon = "applications-games";
        comment = "Launch games with optimal settings";
        categories = ["Game"];
      };
      
      # System monitor
      system-monitor = {
        name = "System Monitor";
        exec = "kitty btop";
        icon = "utilities-system-monitor";
        comment = "Monitor system resources";
        categories = ["System" "Monitor"];
      };
    };
    
    # Configuration files
    configFile = {
      # User directories config
      "user-dirs.locale".text = "en_US";
      
      # Fontconfig user settings
      "fontconfig/conf.d/10-user.conf".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Noto Sans</family>
              <family>Liberation Sans</family>
            </prefer>
          </alias>
          <alias>
            <family>serif</family>
            <prefer>
              <family>Noto Serif</family>
              <family>Liberation Serif</family>
            </prefer>
          </alias>
          <alias>
            <family>monospace</family>
            <prefer>
              <family>JetBrains Mono</family>
              <family>Noto Sans Mono</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
      
      # GTK bookmarks
      "gtk-3.0/bookmarks".text = ''
        file:///home/aural/Documents
        file:///home/aural/Downloads
        file:///home/aural/Projects
        file:///home/aural/Games
        file:///home/aural/Pictures
        file:///home/aural/Videos
        file:///home/aural/Music
      '';
    };
    
    # Data files
    dataFile = {
      # Application shortcuts
      "applications/mimeapps.list".source = config.xdg.configFile."mimeapps.list".source;
      
      # Trash directory setup
      "Trash/info/.keep".text = "";
      "Trash/files/.keep".text = "";
    };
    
    # Cache configuration
    cacheHome = "${config.home.homeDirectory}/.cache";
  };
  
  # Environment variables for XDG
  home.sessionVariables = {
    # XDG base directories are already set by Home Manager
    
    # Application-specific XDG overrides
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    GOPATH = "$XDG_DATA_HOME/go";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
    PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    KUBECONFIG = "$XDG_CONFIG_HOME/kube/config";
    AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
    AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
    
    # Clean up home directory
    LESSHISTFILE = "$XDG_STATE_HOME/less/history";
    HISTFILE = "$XDG_STATE_HOME/bash/history";
    SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
    MYSQL_HISTFILE = "$XDG_DATA_HOME/mysql_history";
    PSQL_HISTORY = "$XDG_DATA_HOME/psql_history";
  };
  
  # Create necessary directories
  home.file = {
    ".local/state/bash/.keep".text = "";
    ".local/state/less/.keep".text = "";
    ".config/npm/.keep".text = "";
    ".config/python/.keep".text = "";
    ".config/docker/.keep".text = "";
    ".config/kube/.keep".text = "";
    ".config/aws/.keep".text = "";
  };
}