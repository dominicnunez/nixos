# modules/development/languages.nix - Programming languages (simplified version)
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Node.js and JavaScript/TypeScript
    # Node.js is managed through fnm (Fast Node Manager)
    # nodePackages.pnpm  # Can be installed via npm/fnm
    # nodePackages.typescript  # Can be installed via npm/fnm
    # nodePackages.typescript-language-server  # Can be installed via npm/fnm
    
    # Node version management
    fnm             # Fast Node Manager (better than nvm)
    
    # Python development
    python312Full
    python312Packages.pip
    python312Packages.virtualenv
    
    # Python tools
    poetry          # Python dependency management
    ruff            # Fast Python linter
    python312Packages.uv  # Fast Python package installer and resolver
    
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
    # GOPATH is not set - Go 1.16+ uses $HOME/go by default
    # Setting GOPATH can cause issues with nix-shell environments
    PATH = "$PATH:$HOME/go/bin:$HOME/.cargo/bin";
  };
  
  # Note: FNM shell integration and nvm alias have been moved to Home Manager
  # See modules/home-manager/terminal.nix
}