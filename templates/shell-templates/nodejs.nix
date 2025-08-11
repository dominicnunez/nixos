# Node.js Development Shell
# Copy this file as shell.nix to your Node.js project root
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Node.js - choose your version
    nodejs_22  # Latest LTS
    # nodejs_20
    # nodejs_18
    
    # Package managers (if not using npm)
    # yarn
    # pnpm
    # bun
    
    # Node development tools
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.nodemon
    
    # Database clients (if needed)
    # postgresql_16
    # redis
    # mongodb-tools
    
    # Testing tools
    # nodePackages.jest
    # playwright-driver
    # cypress
    
    # Build tools
    # nodePackages.webpack
    # nodePackages.vite
    # nodePackages.parcel
    
    # Additional tools
    # docker
    # docker-compose
    # httpie
    # jq
  ];

  shellHook = ''
    echo "Node.js Development Environment"
    echo "Node $(node --version)"
    echo "npm $(npm --version)"
    
    # Auto-install dependencies if package.json exists
    if [ -f package.json ] && [ ! -d node_modules ]; then
      echo "Installing npm dependencies..."
      npm install
    fi
    
    # Set Node environment
    export NODE_ENV=development
    
    # Increase Node memory limit if needed
    # export NODE_OPTIONS="--max-old-space-size=4096"
  '';
  
  # Environment variables
  NODE_ENV = "development";
  
  # Port configuration (adjust as needed)
  PORT = "3000";
  # API_PORT = "3001";
}