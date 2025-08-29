# modules/desktop/applications.nix - Essential desktop applications
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Communication - Start with essentials
    discord
    
    # Music & Media
    spotify
    vlc              # Media player
    
    # Audio Tools (JACK)
    qjackctl         # JACK control GUI
    jack2            # JACK audio connection kit
    carla            # Audio plugin host
    
    # Text-to-Speech
    espeak           # Compact text-to-speech synthesizer
    
    # Development IDE
    # vscode moved to home-manager configuration for better user control
    
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
    
    # E-book Readers
    calibre          # Full-featured e-book manager with reader
    foliate          # Modern, lightweight EPUB reader
    zathura          # Minimalist document viewer with EPUB support
  ];
  
  # Required for proprietary packages
  nixpkgs.config.allowUnfree = true;
}
