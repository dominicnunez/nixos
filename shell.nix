{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Minimal set of tools for NixOS configuration development
    # Most tools are already available system-wide
    
    # Nix development
    nil # Nix LSP
    nixpkgs-fmt # Nix formatter
    
    # For when you need specific versions different from system
    # Uncomment as needed:
    # nodejs_22
    # go
    # python312
  ];

  shellHook = ''
    echo "NixOS configuration development environment"
    echo ""
    echo "System tools available: git, neovim, ripgrep, fd, etc."
    echo "Use project-specific shell.nix for language-specific development"
    echo ""
    echo "Templates available in ./templates/shell-templates/"
  '';
}