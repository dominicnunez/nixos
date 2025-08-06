# modules/desktop/applications.nix - Essential desktop applications
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Communication - Start with essentials
    discord
    
    # Music & Media
    spotify
    vlc              # Media player
    
    # Development IDE
    vscode           # VS Code without extensions initially
    
    # Productivity
    obsidian         # Note-taking
    thunderbird      # Email client (commented out in main config)
    libreoffice      # Office suite
    
    # Graphics & Utilities
    flameshot        # Screenshot tool
    
    # System Utilities for KDE
    kdePackages.ark  # Archive manager for KDE (Qt6 version)
    # kate is already included in user packages
    
    # Password Management
    enpass           # Password manager you actually use
  ];
  
  # Required for proprietary packages
  nixpkgs.config.allowUnfree = true;
}