# modules/desktop/gaming.nix - Gaming configuration with Steam
{ pkgs, config, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true;  # For Steam game servers
  };

  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    # Steam and tools
    steam
    steam-run          # Run non-Steam games in Steam runtime
    steamcmd           # Steam command-line tool
    protontricks       # Tool for Proton/Wine games
    
    # Game launchers
    lutris             # Universal game launcher
    heroic             # Epic Games & GOG launcher
    bottles            # Wine prefix manager
    
    # Wine for Windows games
    wineWowPackages.stable
    winetricks
    
    # Performance tools
    mangohud           # Performance overlay
    gamemode           # Optimize performance for games
    gamescope          # Wayland game compositor
    
    # Controllers
    jstest-gtk         # Joystick testing
    antimicrox         # Map controller to keyboard
    
    # Emulators (optional)
    retroarch          # Multi-system emulator
    dolphin-emu        # GameCube/Wii emulator
    
    # Utilities
    goverlay           # GUI for MangoHud settings
    r2modman           # Mod manager for Unity games
  ];

  # Hardware support for gaming
  hardware = {
    # Graphics support (already configured but ensuring 32-bit for games)
    graphics = {
      enable = true;
      enable32Bit = true;
      
      # Enable Vulkan
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        
        # VA-API support for video acceleration (needed for Electron apps like Notion)
        libva
        libva-utils
        mesa
      ];
      
      # 32-bit support for games
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };
    
    # Steam controller support
    steam-hardware.enable = true;
    
    # Xbox controller support
    xone.enable = false;  # Set to true if you have Xbox One controllers
    xpadneo.enable = true;  # Xbox Bluetooth controllers
  };

  # Enable gamemode (optimizes system for gaming)
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        inhibit_screensaver = 1;
      };
      
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";  # For AMD GPUs
      };
      
      cpu = {
        park_cores = "no";
        pin_query = "yes";
      };
    };
  };

  # Add user to required groups
  users.users.aural = {
    extraGroups = [ 
      "gamemode"  # For GameMode
      "video"     # For GPU access
      "input"     # For controller access
    ];
  };

  # Kernel parameters for better gaming performance
  boot.kernelParams = [
    "quiet"
    "splash"
    # Uncomment for AMD GPUs:
    # "radeon.cik_support=0"
    # "amdgpu.cik_support=1" 
    # "amdgpu.dc=1"
    
    # Uncomment for NVIDIA GPUs:
    # "nvidia-drm.modeset=1"
  ];

  # Better scheduling for gaming
  services.system76-scheduler = {
    enable = true;
    useStockConfig = true;
  };

  # Enable 32-bit support for games
  nixpkgs.config.allowUnfree = true;
  services.pulseaudio.support32Bit = true;
  
  # Fonts for games (some games need Windows fonts)
  fonts.packages = with pkgs; [
    corefonts          # Microsoft Core Fonts
    vistafonts         # Windows Vista fonts
  ];
}
