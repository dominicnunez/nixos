# modules/development/languages.nix - Programming languages (simplified version)
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Node.js and JavaScript/TypeScript
    nodejs_22       # Latest LTS version
    nodePackages.npm
    nodePackages.pnpm
    nodePackages.typescript
    nodePackages.typescript-language-server
    
    # Node version management
    fnm             # Fast Node Manager (better than nvm)
    
    # Python development
    python312Full
    python312Packages.pip
    python312Packages.virtualenv
    
    # Python tools
    poetry          # Python dependency management
    ruff            # Fast Python linter
    
    # Go development (if you need it)
    go
    gopls           # Go language server
    
    # Rust (optional but useful)
    rustc
    cargo
    rust-analyzer
  ];

  # Python is configured via environment.systemPackages above

  # Environment variables for development
  environment.variables = {
    GOPATH = "$HOME/go";
    PATH = "$PATH:$HOME/go/bin:$HOME/.cargo/bin";
  };
  
  # FNM (Fast Node Manager) shell integration
  programs.bash.interactiveShellInit = ''
    # Initialize fnm if available
    if command -v fnm &> /dev/null; then
      eval "$(fnm env --use-on-cd)"
    fi
  '';
  
  # Create fnm alias for nvm compatibility
  environment.shellAliases = {
    nvm = "fnm";  # Alias for compatibility with projects expecting nvm
  };
}