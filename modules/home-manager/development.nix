# modules/home-manager/development.nix - Development tools and Git configuration
{ config, pkgs, lib, ... }:

{
  # Enhanced Git configuration
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Dominic";
        email = "dominicnunez@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";

      # Better diff and merge
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      diff.algorithm = "histogram";

      # Performance
      core.preloadindex = true;
      core.fscache = true;
      gc.auto = 256;

      # Rebase
      rebase.autoStash = true;
      rebase.autoSquash = true;

      # Fetch
      fetch.prune = true;
      fetch.prunetags = true;

      # Better log
      log.date = "relative";
      format.pretty = "format:%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s";

      # URL shortcuts
      url."git@github.com:".insteadOf = "gh:";
      url."git@gitlab.com:".insteadOf = "gl:";
      url."git@bitbucket.org:".insteadOf = "bb:";

      # Git aliases
      alias = {
      # Status and info
      st = "status -sb";
      s = "status -s";

      # Commits
      ci = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      can = "commit --amend --no-edit";

      # Branches
      br = "branch";
      co = "checkout";
      cob = "checkout -b";
      brd = "branch -d";
      brD = "branch -D";

      # Staging
      a = "add";
      aa = "add --all";
      ap = "add --patch";
      unstage = "reset HEAD --";

      # Diffs
      d = "diff";
      ds = "diff --staged";
      dt = "difftool";

      # Logs
      l = "log --oneline --graph --decorate";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      last = "log -1 HEAD --stat";

      # Remote
      f = "fetch";
      fa = "fetch --all";
      p = "push";
      pf = "push --force-with-lease";
      pl = "pull";

      # Stash
      ss = "stash save";
      sp = "stash pop";
      sl = "stash list";

      # Reset
      r = "reset";
      r1 = "reset HEAD^";
      r2 = "reset HEAD^^";
      rh = "reset --hard";
      rh1 = "reset HEAD^ --hard";
      rh2 = "reset HEAD^^ --hard";

      # Cherry-pick
      cp = "cherry-pick";
      cpa = "cherry-pick --abort";
      cpc = "cherry-pick --continue";

      # Rebase
      rb = "rebase";
      rbi = "rebase -i";
      rbc = "rebase --continue";
      rba = "rebase --abort";
      rbs = "rebase --skip";

      # Utils
      aliases = "config --get-regexp alias";
      whoami = "config user.name";

      # Find
      find = "!git ls-files | grep -i";
      grep = "grep -Ii";
      };
    };

    # Ignore global files
    ignores = [
      # OS
      ".DS_Store"
      "Thumbs.db"
      "*.swp"
      "*.swo"
      "*~"

      # IDE
      ".idea/"
      ".vscode/"
      "*.iml"
      ".project"
      ".classpath"
      ".settings/"

      # Languages
      "__pycache__/"
      "*.pyc"
      "node_modules/"
      ".npm/"
      "target/"
      "*.class"

      # Env
      ".env"
      ".env.local"
      ".envrc"

      # Logs
      "*.log"
      "logs/"

      # Build
      "dist/"
      "build/"
      "out/"
      "*.o"
      "*.so"
      "*.dylib"
      "*.dll"
    ];
  };

  # Delta - better git diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Dracula";
      features = "decorations";
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "cyan box ul";
      };
    };
  };

  # Lazygit - Terminal UI for git
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          selectedLineBgColor = ["reverse"];
          selectedRangeBgColor = ["reverse"];
        };
        showFileTree = true;
        showCommandLog = true;
        showBottomLine = true;
        nerdFontsVersion = "3";
      };

      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        commit = {
          signOff = false;
        };
        merging = {
          manualCommit = false;
          args = "";
        };
      };

      os = {
        editCommand = "nvim";
        editCommandTemplate = "{{editor}} {{filename}}";
        openCommand = "xdg-open {{filename}}";
      };

      keybinding = {
        universal = {
          quit = "q";
          quit-alt1 = "<c-c>";
          return = "<esc>";
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>";
          prevItem = "<up>";
          nextItem = "<down>";
          prevBlock = "<left>";
          nextBlock = "<right>";
          prevPage = "<c-b>";
          nextPage = "<c-f>";
          scrollLeft = "h";
          scrollRight = "l";
          scrollUpMain = "<c-u>";
          scrollDownMain = "<c-d>";
          refresh = "R";
        };
      };

      customCommands = [
        {
          key = "C";
          command = "git cz";
          context = "files";
          description = "commit with commitizen";
        }
      ];
    };
  };

  # Gitui - Fast terminal UI for git (Rust-based)
  programs.gitui = {
    enable = true;
    keyConfig = ''
      (
        open_help: Some(( code: F(1), modifiers: "")),

        move_left: Some(( code: Char('h'), modifiers: "")),
        move_right: Some(( code: Char('l'), modifiers: "")),
        move_up: Some(( code: Char('k'), modifiers: "")),
        move_down: Some(( code: Char('j'), modifiers: "")),

        popup_up: Some(( code: Char('p'), modifiers: "CONTROL")),
        popup_down: Some(( code: Char('n'), modifiers: "CONTROL")),
        page_up: Some(( code: Char('b'), modifiers: "CONTROL")),
        page_down: Some(( code: Char('f'), modifiers: "CONTROL")),
        home: Some(( code: Char('g'), modifiers: "")),
        end: Some(( code: Char('G'), modifiers: "SHIFT")),

        shift_up: Some(( code: Char('K'), modifiers: "SHIFT")),
        shift_down: Some(( code: Char('J'), modifiers: "SHIFT")),

        status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
        diff_reset_lines: Some(( code: Char('u'), modifiers: "")),
        diff_stage_lines: Some(( code: Char('s'), modifiers: "")),

        stashing_save: Some(( code: Char('w'), modifiers: "")),
        stashing_toggle_index: Some(( code: Char('m'), modifiers: "")),

        edit_file: Some(( code: Char('I'), modifiers: "SHIFT")),

        select_status: Some(( code: Tab, modifiers: "")),
        select_branch: Some(( code: Char('b'), modifiers: "")),
        select_commit: Some(( code: Char('l'), modifiers: "")),
        select_stash: Some(( code: Char('s'), modifiers: "")),

        open_commit: Some(( code: Enter, modifiers: "")),
        open_commit_editor: Some(( code: Char('e'), modifiers: "")),

        undo_commit: Some(( code: Char('U'), modifiers: "SHIFT")),

        toggle_diff_stage: Some(( code: Char('s'), modifiers: "")),
        toggle_file_tree: Some(( code: Char('t'), modifiers: "")),

        push: Some(( code: Char('p'), modifiers: "")),
        pull: Some(( code: Char('f'), modifiers: "")),

        quit: Some(( code: Char('q'), modifiers: "")),
      )
    '';
    theme = ''
      (
        selected_tab: Cyan,
        command_fg: Gray,
        selection_bg: Blue,
        cmdbar_bg: Blue,
        cmdbar_extra_lines_bg: Blue,
        disabled_fg: DarkGray,
        diff_line_add: Green,
        diff_line_delete: Red,
        diff_file_added: LightGreen,
        diff_file_removed: LightRed,
        diff_file_moved: LightMagenta,
        diff_file_modified: Yellow,
        commit_hash: Magenta,
        commit_time: LightCyan,
        commit_author: Green,
        danger_fg: Red,
        push_gauge_bg: Blue,
        push_gauge_fg: Reset,
        tag_fg: LightMagenta,
        branch_fg: LightYellow,
      )
    '';
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pc = "pr create";
        pl = "pr list";
        rv = "repo view";
        rc = "repo clone";
        il = "issue list";
        iv = "issue view";
        ic = "issue create";
      };
    };
  };

  # Development packages
  home.packages = with pkgs; [
    # Git tools
    git-lfs
    git-filter-repo
    git-crypt
    git-extras
    git-open
    diff-so-fancy
    hub
    tig

    # Code formatting and linting
    pre-commit
    commitizen
    nixpkgs-fmt  # Nix code formatter for VS Code and CLI

    # Development utilities
    jq
    yq
    httpie
    curlie

    # Documentation
    mdbook
    pandoc

    # ==== Language-Specific Development Tools ====

    # Python Development
    python312
    python312Packages.pip
    python312Packages.virtualenv
    python312Packages.ipython
    python312Packages.black
    python312Packages.pytest
    poetry
    ruff

    # JavaScript/TypeScript Development
    nodejs_22  # Comes with npm 10.9.2
    # Note: npm 11.5.2 needs to be installed via: npm install -g npm@11.5.2
    nodePackages.pnpm
    # nodePackages.typescript  # Removed to avoid collision with gemini-cli
    # nodePackages.typescript-language-server  # Install via npm when needed
    # nodePackages.prettier  # Removed to avoid collision with gemini-cli
    # Note: Install TypeScript/Prettier tools via npm globally: npm install -g typescript typescript-language-server prettier

    # Rust Development
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

    # Go Development
    go
    gopls
    golangci-lint

    # Go development tools
    go-outline         # Go code outline
    gomodifytags       # Modify struct tags
    gotests            # Generate tests
    gocode-gomod       # Autocomplete daemon

    # Code quality tools
    govulncheck        # Vulnerability checker
    go-tools           # Additional tools (staticcheck, etc.)

    # Debugging and profiling
    delve              # Debugger
    gore               # REPL
    graphviz           # For pprof graphs
    
    # Debugging and Profiling
    hyperfine  # Command-line benchmarking
    tokei  # Count lines of code
  ];

  # Language-specific environment variables
  home.sessionVariables = {
    # Python
    PYTHONDONTWRITEBYTECODE = "1";
    PYTHONUNBUFFERED = "1";
    
    # npm global directory for user-installed packages
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";

    # Update PATH for language tools
    PATH = "$PATH:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$HOME/.local/bin";
  };
  
  # Activation script to ensure npm 11.5.2 is installed
  home.activation.npmUpgrade = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create npm directories if they don't exist
    mkdir -p $HOME/.npm-global
    mkdir -p $HOME/.npm
    
    # Set proper npm cache directory
    export npm_config_cache=$HOME/.npm
    export NPM_CONFIG_PREFIX=$HOME/.npm-global
    
    # Check if npm 11.5.2 is already installed in .npm-global
    if [ -f "$HOME/.npm-global/lib/node_modules/npm/package.json" ]; then
      INSTALLED_VERSION=$(${pkgs.jq}/bin/jq -r '.version' $HOME/.npm-global/lib/node_modules/npm/package.json 2>/dev/null || echo "0.0.0")
    else
      INSTALLED_VERSION="0.0.0"
    fi
    
    TARGET_NPM_VERSION="11.5.2"
    
    if [ "$INSTALLED_VERSION" != "$TARGET_NPM_VERSION" ]; then
      echo "Installing npm version $TARGET_NPM_VERSION..."
      ${pkgs.nodejs_22}/bin/npm install -g npm@$TARGET_NPM_VERSION --prefix=$HOME/.npm-global --cache=$HOME/.npm
      echo "npm $TARGET_NPM_VERSION installed successfully"
    else
      echo "npm $TARGET_NPM_VERSION is already installed"
    fi
  '';

  # Shell aliases for development tools
  programs.bash.shellAliases = {
    # Git shortcuts (in addition to git aliases)
    g = "git";
    lg = "lazygit";
    gu = "gitui";

    # GitHub CLI
    ghpr = "gh pr";
    ghis = "gh issue";
    ghrp = "gh repo";

    # Development
    http = "httpie";
    curl = "curlie";

    # Python
    py = "python";
    py3 = "python3";
    ipy = "ipython";
    pip = "pip3";
    venv = "python -m venv";
    activate = "source ./venv/bin/activate";

    # Node.js
    ni = "npm install";
    nr = "npm run";
    ns = "npm start";
    nt = "npm test";
    nb = "npm run build";

    # Rust
    cb = "cargo build";
    cr = "cargo run";
    ct = "cargo test";
    cc = "cargo check";
    cf = "cargo fmt";
    cl = "cargo clippy";

    # Docker
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    dimg = "docker images";

    # Kubernetes
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kaf = "kubectl apply -f";
    kdel = "kubectl delete";
    klog = "kubectl logs";
    kexec = "kubectl exec -it";
  };

  # Additional language-specific configurations can be added here
  # For example, rustup configuration, poetry config, etc.
}
