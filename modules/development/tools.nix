# modules/development/tools.nix - Essential development tools
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Version control
    git
    git-lfs
    gh                  # GitHub CLI
    
    # Terminal tools - start with essentials
    tmux
    
    # Modern CLI tools (better alternatives)
    ripgrep            # Better grep
    fd                 # Better find
    fzf                # Fuzzy finder
    eza                # Modern ls replacement (better than exa)
    bat                # Cat with syntax highlighting
    tree
    ncdu               # Disk usage analyzer
    
    # System monitoring
    htop
    btop               # Better htop
    iotop
    lsof
    neofetch           # System information display
    
    # Network tools
    curl
    wget
    httpie             # User-friendly HTTP client
    
    # Development utilities
    jq                 # JSON processor
    yq                 # YAML processor
    
    # Text editors (basic)
    neovim
    
    # Misc productivity
    tldr               # Simplified man pages
  ];

  # Git configuration moved to Home Manager
  # programs.git = {
  #   enable = true;
  #   config = {
  #     init.defaultBranch = "main";
  #     pull.rebase = true;
  #     push.autoSetupRemote = true;
  #     core.editor = "nvim";
  #   };
  # };
  
  # Neovim configuration moved to Home Manager
  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  # };
  
  # Shell aliases moved to Home Manager
  # environment.shellAliases = {
  #   ll = "eza -l";
  #   la = "eza -la";
  #   lt = "eza --tree";
  #   ".." = "cd ..";
  #   "..." = "cd ../..";
  #   gs = "git status";
  #   gc = "git commit";
  #   gp = "git push";
  #   gl = "git pull";
  #   gd = "git diff";
  #   cat = "bat";
  #   find = "fd";
  # };
}