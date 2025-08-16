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
    protonup-qt        # Manage Proton GE versions for Steam
    
    # Game launchers
    lutris             # Universal game launcher
    heroic             # Epic Games & GOG launcher
    bottles            # Wine prefix manager
    
    # Wine for Windows games
    wineWowPackages.staging  # Use staging for better compatibility
    winetricks
    
    # DirectX and DXVK support (critical for PoE2)
    dxvk               # DirectX to Vulkan translation layer
    vkd3d              # Direct3D 12 to Vulkan translation
    vkd3d-proton       # Proton's fork of VKD3D
    
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

  # Hardware support for gaming and desktop acceleration
  hardware = {
    # Graphics support with full hardware acceleration
    graphics = {
      enable = true;
      enable32Bit = true;
      
      # Enable Vulkan and OpenGL acceleration
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        vulkan-extension-layer  # Additional Vulkan extensions
        
        # VA-API support for video acceleration
        libva
        libva-utils
        
        # Mesa drivers for AMD GPUs with full acceleration
        mesa
        # mesa.drivers is deprecated, mesa includes drivers now
        
        # GPU-specific acceleration packages are in gpu-acceleration.nix
        
        # Additional video acceleration
        vaapiVdpau
        libvdpau-va-gl
      ];
      
      # 32-bit support for games
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        mesa
        # mesa.drivers is deprecated, mesa includes drivers now
        vulkan-loader  # 32-bit Vulkan loader for compatibility
        dxvk           # 32-bit DXVK support
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
        # Performance level is auto-managed by NVIDIA drivers
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

  # Kernel parameters for better gaming and desktop performance
  boot.kernelParams = [
    "quiet"
    "splash"
    
    # GPU-specific kernel parameters are now in gpu-acceleration.nix
    
    # Additional performance tuning
    "transparent_hugepage=always"        # Better memory performance
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
