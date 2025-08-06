# modules/development/productivity.nix - Advanced Git and productivity tools
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === ADVANCED GIT TOOLS ===
    
    # Lazygit - Terminal UI for Git (HIGHLY RECOMMENDED)
    # - Interactive staging, committing, pushing
    # - Branch visualization and management
    # - Merge conflict resolution
    # - Stash management
    # - Usage: just type 'lazygit' in any git repo
    lazygit
    
    # GitUI - Blazing fast terminal Git GUI (Rust-based)
    # - Faster alternative to lazygit
    # - Keyboard-driven interface
    # - Usage: type 'gitui' in any git repo
    gitui
    
    # Tig - Text-mode interface for Git
    # - Browse commits, blame, diff
    # - Less interactive than lazygit but very fast
    # - Usage: 'tig' for log view, 'tig status' for status
    tig
    
    # Delta - Better git diff viewer
    # - Syntax highlighting for diffs
    # - Side-by-side view
    # - Line numbers
    # Git will use this automatically once installed
    delta
    
    # Git extras - Additional git commands
    # - git undo, git info, git changelog
    # - git delete-branch, git pr
    # - 60+ extra commands
    gitAndTools.git-extras
    
    # Hub - GitHub from the command line
    # - Create PRs: 'hub pull-request'
    # - Clone repos: 'hub clone user/repo'
    # - Browse issues: 'hub issue'
    gitAndTools.hub
    
    # Git interactive rebase tool
    git-interactive-rebase-tool
    
    # Commitizen - Conventional commits
    commitizen
    
    # === PRODUCTIVITY TOOLS ===
    
    # Zoxide - Smarter cd command (GAME CHANGER!)
    # - Learns your most used directories
    # - Jump to any directory: 'z proj' → /home/user/projects/my-project
    # - Interactive selection: 'zi' 
    # - Replaces cd completely after you get used to it
    zoxide
    
    # Atuin - Better shell history (AMAZING!)
    # - Syncs history across machines
    # - Fuzzy search through all your commands
    # - Stats about your command usage
    # - Usage: Ctrl+R for search (replaces default)
    atuin
    
    # FZF - Fuzzy finder for everything
    # - Ctrl+R: fuzzy search command history
    # - Ctrl+T: fuzzy search files
    # - Alt+C: fuzzy search directories
    # - '**<Tab>': fuzzy complete anything
    fzf
    
    # Clipboard managers
    copyq               # GUI clipboard manager with history
    wl-clipboard        # Wayland clipboard utilities
    xclip              # X11 clipboard utilities
    
    # Application launchers
    ulauncher          # Fast app launcher (like macOS Spotlight)
    rofi               # Window switcher and launcher
    
    # File managers
    nnn                # Super fast terminal file manager
    broot              # Modern tree/file navigator
    xplr               # Hackable terminal file explorer
    
    # Terminal multiplexers
    byobu              # Enhanced tmux/screen
    
    # Task management
    taskwarrior3       # Command-line task management (v3)
    # taskwarrior-tui    # TUI for taskwarrior (may need update for v3)
    
    # Process management
    procs              # Modern ps replacement
    bottom             # Another top/htop alternative
    zenith             # System monitor
    
    # Modern CLI replacements
    duf                # Better df
    dust               # Better du
    gping              # Ping with graph
    xh                 # Better HTTPie
    
    # File watching and automation
    watchexec          # Execute commands when files change
    entr               # Run commands when files change
  ];
  
  # Note: Git delta and advanced configuration would require home-manager
  # Users can configure git in their ~/.gitconfig
  # Delta can be configured with:
  # [core]
  #     pager = delta
  # [delta]
  #     navigate = true
  #     light = false
  #     line-numbers = true
  #     side-by-side = true
  #     theme = "Dracula"
  
  # Shell integrations
  programs.bash.interactiveShellInit = ''
    # Zoxide (smarter cd)
    eval "$(zoxide init bash)"
    
    # Atuin (better history)
    eval "$(atuin init bash)"
    
    # FZF key bindings
    source ${pkgs.fzf}/share/fzf/key-bindings.bash
    source ${pkgs.fzf}/share/fzf/completion.bash
    
    # Aliases for productivity
    alias cd='z'  # Use zoxide instead of cd
    alias cdi='zi'  # Interactive directory jump
    alias lg='lazygit'
    alias g='git'
    alias cat='bat'  # Better cat with syntax highlighting
    alias ls='eza'   # Better ls
    alias find='fd'  # Better find
    alias ps='procs' # Better ps
    alias top='btop' # Better top
    alias df='duf'   # Better df
    alias du='dust'  # Better du
  '';
  
  programs.fish.interactiveShellInit = ''
    # Zoxide
    zoxide init fish | source
    
    # Atuin
    atuin init fish | source
    
    # FZF
    fzf --fish | source
    
    # Aliases
    alias cd='z'
    alias cdi='zi'
    alias lg='lazygit'
    alias g='git'
  '';
  
  # FZF configuration
  environment.variables = {
    FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --preview 'bat --color=always {}'";
    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
    FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
    FZF_ALT_C_COMMAND = "fd --type d --hidden --follow --exclude .git";
  };
}