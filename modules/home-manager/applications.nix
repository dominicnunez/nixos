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

    # Default profile with settings and extensions
    profiles = {
      default = {
        # User settings
        userSettings = {
          # Editor settings
          "editor.fontSize" = 14;
          "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', 'Cascadia Code', 'Fira Code', monospace";
          "editor.fontLigatures" = true;
          "editor.lineHeight" = 22;
          "editor.rulers" = [80 120];
          "editor.wordWrap" = "on";
          "editor.minimap.enabled" = false;
          "editor.renderWhitespace" = "selection";
          "editor.suggestSelection" = "first";
          "editor.acceptSuggestionOnCommitCharacter" = false;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
          "editor.inlineSuggest.enabled" = true;
          "editor.cursorStyle" = "line";
          "editor.smoothScrolling" = true;
          "editor.cursorBlinking" = "smooth";
          "editor.bracketPairColorization.enabled" = true;
          "editor.guides.bracketPairs" = "active";
          "editor.stickyScroll.enabled" = true;
          "editor.linkedEditing" = true;
          "editor.tabSize" = 2;

          # Workbench settings
          "workbench.colorTheme" = "Dracula";
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.startupEditor" = "none";
          "workbench.sideBar.location" = "left";
          "workbench.activityBar.location" = "default";
          "workbench.statusBar.visible" = true;
          "workbench.tree.indent" = 15;
          "workbench.tree.renderIndentGuides" = "always";
          "workbench.editor.enablePreview" = false;
          "workbench.editor.revealIfOpen" = true;

          # Terminal settings
          "terminal.integrated.fontSize" = 14;
          "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono'";
          "terminal.integrated.defaultProfile.linux" = "bash";
          "terminal.integrated.cursorBlinking" = true;
          "terminal.integrated.cursorStyle" = "line";
          "terminal.integrated.smoothScrolling" = true;
          "terminal.integrated.copyOnSelection" = true;

          # File settings
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "files.trimTrailingWhitespace" = true;
          "files.insertFinalNewline" = true;
          "files.trimFinalNewlines" = true;
          "files.eol" = "\n";
          "files.exclude" = {
            "**/.git" = false;
            "**/.DS_Store" = true;
            "**/node_modules" = true;
            "**/__pycache__" = true;
            "**/*.pyc" = true;
          };
          "files.watcherExclude" = {
            "**/.git/objects/**" = true;
            "**/.git/subtree-cache/**" = true;
            "**/node_modules/**" = true;
            "**/.venv/**" = true;
            "**/venv/**" = true;
          };

          # Explorer settings
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" = false;
          "explorer.compactFolders" = false;

          # Git settings
          "git.enableSmartCommit" = true;
          "git.confirmSync" = false;
          "git.autofetch" = true;
          "git.autoStash" = true;
          "git.openRepositoryInParentFolders" = "always";

          # Search settings
          "search.exclude" = {
            "**/node_modules" = true;
            "**/bower_components" = true;
            "**/*.code-search" = true;
            "**/.venv" = true;
            "**/venv" = true;
            "**/__pycache__" = true;
          };
          "search.useIgnoreFiles" = true;
          "search.followSymlinks" = false;

          # Extension settings
          "extensions.ignoreRecommendations" = false;
          "extensions.autoUpdate" = true;
          "extensions.autoCheckUpdates" = true;

          # Telemetry
          "telemetry.telemetryLevel" = "off";

          # Window settings
          "window.zoomLevel" = 0;
          "window.menuBarVisibility" = "toggle";

          # Update settings
          "update.mode" = "manual";
          "update.showReleaseNotes" = false;

          # Security
          "security.workspace.trust.untrustedFiles" = "open";

          # Language-specific formatters and settings
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[javascriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[json]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[jsonc]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[html]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[css]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[scss]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[markdown]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.wordWrap" = "on";
          };
          "[yaml]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };
          "[python]" = {
            "editor.defaultFormatter" = "ms-python.black-formatter";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 4;
          };
          "[rust]" = {
            "editor.defaultFormatter" = "rust-lang.rust-analyzer";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 4;
          };
          "[go]" = {
            "editor.defaultFormatter" = "golang.go";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 4;
          };
          "[dockerfile]" = {
            "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
            "editor.formatOnSave" = true;
          };
          "[toml]" = {
            "editor.defaultFormatter" = "tamasfe.even-better-toml";
            "editor.formatOnSave" = true;
          };

          # Prettier configuration
          "prettier.semi" = true;
          "prettier.singleQuote" = true;
          "prettier.tabWidth" = 2;
          "prettier.useTabs" = false;
          "prettier.trailingComma" = "es5";
          "prettier.bracketSpacing" = true;
          "prettier.arrowParens" = "avoid";
          "prettier.endOfLine" = "lf";

          # Python settings
          "python.defaultInterpreterPath" = "python3";
          "python.linting.enabled" = true;
          "python.linting.lintOnSave" = true;
          "python.formatting.provider" = "black";
          "python.linting.pylintEnabled" = false;
          "python.linting.flake8Enabled" = true;
          "python.testing.pytestEnabled" = true;
          "python.testing.unittestEnabled" = false;

          # JavaScript/TypeScript settings
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "typescript.updateImportsOnFileMove.enabled" = "always";
          "javascript.suggest.autoImports" = true;
          "typescript.suggest.autoImports" = true;

          # ESLint settings
          "eslint.validate" = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
          "eslint.autoFixOnSave" = true;

          # Emmet settings
          "emmet.includeLanguages" = {
            "javascript" = "javascriptreact";
            "typescript" = "typescriptreact";
          };
          "emmet.triggerExpansionOnTab" = true;

          # Bracket pair colorization
          "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;

          # GitLens settings
          "gitlens.currentLine.enabled" = false;
          "gitlens.codeLens.enabled" = false;
          "gitlens.hovers.currentLine.over" = "line";

          # Error Lens settings (when installed)
          "errorLens.enabled" = true;
          "errorLens.enabledDiagnosticLevels" = ["error" "warning" "info"];

          # Live Server settings (when installed)
          "liveServer.settings.donotShowInfoMsg" = true;
          "liveServer.settings.donotVerifyTags" = true;

          # Material Icon Theme settings
          "material-icon-theme.folders.theme" = "specific";
          "material-icon-theme.activeIconPack" = "nest";

          # Todo Tree settings (when installed)
          "todo-tree.highlights.enabled" = true;
          "todo-tree.highlights.defaultHighlight" = {
            "icon" = "alert";
            "type" = "text";
            "foreground" = "#ff0000";
            "background" = "#ffffff";
            "opacity" = 50;
            "iconColour" = "#0000ff";
          };

          # Spell Checker settings (when installed)
          "cSpell.language" = "en";
          "cSpell.userWords" = [];
        };

        # Extensions to install
        extensions = with pkgs.vscode-extensions; [
      # Themes
      dracula-theme.theme-dracula
      pkief.material-icon-theme

      # General
      # editorconfig.editorconfig
      # streetsidesoftware.code-spell-checker
      # usernamehw.errorlens
      # gruntfuggly.todo-tree

      # Git
      eamodio.gitlens
      mhutchie.git-graph
      donjayamanne.githistory

      # Nix
      jnoortheen.nix-ide

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
      tamasfe.even-better-toml
      # dependi (need to get actual ext name)

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
      # ms-vscode-remote.remote-ssh
      # ms-vscode-remote.remote-containers
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
