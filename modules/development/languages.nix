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
  
  # Note: FNM shell integration and nvm alias have been moved to Home Manager
  # See modules/home-manager/terminal.nix
}