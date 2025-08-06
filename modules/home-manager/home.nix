# modules/home-manager/home.nix - User-specific Home Manager configuration
{ config, pkgs, lib, ... }:

{
  # Import additional modules
  imports = [
    ./neovim.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aural";
  home.homeDirectory = "/home/aural";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Basic user packages (these will be available only to this user)
  home.packages = with pkgs; [
    # We'll add user-specific packages here as we migrate
  ];

  # Basic configuration to start
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Git configuration (migrated from system-wide)
  programs.git = {
    enable = true;
    userName = "Aural"; # Update with your actual name
    userEmail = "your-email@example.com"; # Update with your actual email
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      
      # Additional useful git settings
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      fetch.prune = true;
    };
    
    # Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    
    # Shell aliases (migrated from system-wide)
    shellAliases = {
      # Navigation
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Git shortcuts (complement git aliases)
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      
      # Modern replacements
      cat = "bat";
      find = "fd";
      
      # Convenience
      cls = "clear";
      mkdir = "mkdir -pv";
      df = "df -h";
      du = "du -h";
    };
    
    # Bash-specific settings
    initExtra = ''
      # Better history
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=10000
      export HISTFILESIZE=10000
      shopt -s histappend
      
      # Enable vi mode (optional, comment out if you prefer emacs mode)
      set -o vi
      
      # Better tab completion
      bind "set completion-ignore-case on"
      bind "set show-all-if-ambiguous on"
      
      # Colored GCC warnings and errors
      export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    '';
  };

  # FZF configuration
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always {}'"
    ];
    
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # Atuin (better shell history)
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    
    settings = {
      auto_sync = false;
      sync_frequency = "0";
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  # Direnv integration
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}