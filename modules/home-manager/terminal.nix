# modules/home-manager/terminal.nix - Terminal and shell configurations
{ config, pkgs, lib, ... }:

let
  # Import aliases from dedicated file
  aliases = import ./aliases.nix { inherit config pkgs lib; };
in
{
  # Enhanced Bash configuration
  programs.bash = {
    enable = true;
    
    # Use imported aliases
    shellAliases = aliases.shellAliases;
    
    # Bash-specific settings
    initExtra = ''
      # Ensure ~/.local/bin is first in PATH (for user wrappers like claude)
      export PATH="$HOME/.local/bin:$PATH"

      # Better history
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=100000
      export HISTFILESIZE=100000
      shopt -s histappend
      
      # Enable vi mode
      set -o vi
      
      # Better tab completion
      bind "set completion-ignore-case on"
      bind "set show-all-if-ambiguous on"
      bind "set mark-symlinked-directories on"
      
      # Colored GCC warnings and errors
      export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
      
      # Custom prompt with git branch
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }
      
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '
      
      # FNM (Fast Node Manager) integration
      if command -v fnm &> /dev/null; then
        eval "$(fnm env --use-on-cd)"
      fi
      
      # Productivity tool integrations (from productivity.nix)
      # These are handled by the programs below but kept for reference
    '';
    
    # Enable bash completion
    enableCompletion = true;
  };
  
  # Fish shell configuration (optional alternative)
  programs.fish = {
    enable = false;  # Set to true if you want to use fish
    
    # Use imported aliases
    shellAliases = aliases.shellAliases;
    
    interactiveShellInit = ''
      # Fish-specific configuration
      set -g fish_greeting # Disable greeting
      
      # Vi mode
      fish_vi_key_bindings
    '';
  };
  
  # Zsh configuration (optional alternative)
  programs.zsh = {
    enable = false;  # Set to true if you want to use zsh
    
    # Use imported aliases
    shellAliases = aliases.shellAliases;
    
    initExtra = ''
      # Enable vi mode
      bindkey -v
      
      # Better history
      HISTSIZE=100000
      SAVEHIST=100000
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt SHARE_HISTORY
    '';
    
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
  
  # Starship prompt (works with all shells)
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = false;  # Enable if using fish
    enableZshIntegration = false;   # Enable if using zsh
    
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$python"
        "$nodejs"
        "$rust"
        "$golang"
        "$character"
      ];
      
      directory = {
        style = "blue bold";
        truncation_length = 3;
        truncate_to_repo = false;
      };
      
      git_branch = {
        format = "[$branch]($style) ";
        style = "bright-yellow";
      };
      
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "red";
      };
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vicmd_symbol = "[➜](bold yellow)";
      };
      
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
      };
    };
  };
  
  # Terminal emulator configurations
  programs.kitty = {
    enable = true;
    
    settings = {
      # Font configuration
      font_family = "JetBrains Mono";
      font_size = 11;
      
      # Colors (Dracula theme)
      background = "#282a36";
      foreground = "#f8f8f2";
      selection_background = "#44475a";
      selection_foreground = "#f8f8f2";
      
      # Cursor
      cursor = "#f8f8f2";
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      
      # Window
      window_padding_width = 5;
      hide_window_decorations = false;
      
      # Tabs
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
    };
    
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+]" = "next_tab";
      "ctrl+shift+[" = "previous_tab";
    };
  };
  
  # Screen package (alternative to tmux)
  # Note: Home Manager doesn't have programs.screen, so we just install the package
  # home.packages = with pkgs; [ screen ];  # Uncomment to use screen
  
  # Environment variables
  home.sessionVariables = {
    # Editor
    EDITOR = "nvim";
    VISUAL = "nvim";
    
    # Pager
    PAGER = "less";
    LESS = "-R";
    
    # Man pages
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    
    # FZF configuration is handled by programs.fzf in home.nix
    
    # Colored ls (for systems without eza)
    LS_COLORS = "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32";
  };
  
  # Shell integrations are in home.nix (zoxide, atuin, fzf, direnv)
  # They're already configured there and work across all shells
}