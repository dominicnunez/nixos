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
    
    # Wine for Windows games - Full package for maximum compatibility
    wineWowPackages.stagingFull  # Full staging with all features
    winetricks
    
    # DirectX and DXVK support (critical for PoE2)
    dxvk               # DirectX to Vulkan translation layer
    dxvk_2            # DXVK 2.x for newer DirectX support
    vkd3d              # Direct3D 12 to Vulkan translation
    vkd3d-proton       # Proton's fork of VKD3D
    
    # Additional Wine/Proton dependencies for PoE2
    cabextract         # Extract Windows cabinet files
    p7zip              # Archive support
    unzip              # ZIP support
    zenity             # GUI dialogs for Wine
    
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
    
    # System libraries that Wine/Proton might need
    gnutls             # TLS support
    openldap           # LDAP support
    libgpg-error       # GPG error handling
    sqlite             # Database support
    libxml2            # XML parsing
    libxslt            # XSLT support
    
    # Audio libraries
    alsa-lib
    alsa-plugins
    
    # Graphics libraries
    freetype
    fontconfig
    lcms2              # Color management
    
    # Compression libraries
    bzip2
    zlib
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
        vulkan-headers         # Vulkan headers for compatibility
        spirv-tools           # SPIR-V tools for shader compilation
        
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
        
        # Additional libraries for Wine/Proton compatibility
        ocl-icd           # OpenCL support
        libglvnd          # GL Vendor-Neutral Dispatch library
      ];
      
      # 32-bit support for games
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        mesa
        # mesa.drivers is deprecated, mesa includes drivers now
        vulkan-loader     # 32-bit Vulkan loader for compatibility
        vulkan-tools      # 32-bit Vulkan tools
        dxvk             # 32-bit DXVK support
        vkd3d            # 32-bit VKD3D support
        vkd3d-proton     # 32-bit VKD3D-Proton
        libglvnd         # 32-bit GL dispatch
        pipewire         # 32-bit audio support
        libpulseaudio    # 32-bit PulseAudio
        openal           # 32-bit OpenAL audio
        ocl-icd          # 32-bit OpenCL
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
  
  # System-level Wine/Proton configuration for Path of Exile 2
  environment.variables = {
    # Steam runtime configuration
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";  # Use Steam runtime libs
    STEAM_RUNTIME = "1";                        # Enable Steam runtime
    
    # Path of Exile 2 specific fixes
    PROTON_NO_ESYNC = "0";     # Enable ESYNC for better performance
    PROTON_NO_FSYNC = "0";     # Enable FSYNC if kernel supports it
    
    # DirectX factory fixes
    DXVK_HUD = "compiler";     # Show DXVK compiler activity (can be disabled later)
    
    # Wine prefix configuration
    WINEPREFIX = "$HOME/.wine";  # Default Wine prefix location
    WINEARCH = "win64";          # Use 64-bit Wine architecture
  };
  
  # Kernel configuration for ESYNC/FSYNC support
  boot.kernel.sysctl = {
    # Increase the limit for ESYNC
    "vm.max_map_count" = 2147483642;
    
    # Increase file descriptor limits for ESYNC
    "fs.file-max" = 524288;
  };
  
  # Security limits for gaming
  security.pam.loginLimits = [
    {
      domain = "@users";
      type = "soft";
      item = "nofile";
      value = "524288";
    }
    {
      domain = "@users";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];
  
  # Create a helper script for Path of Exile 2 launch options
  environment.etc."poe2-launch-options.txt" = {
    text = ''
      # Path of Exile 2 Steam Launch Options
      # Copy this line to Steam -> Path of Exile 2 -> Properties -> Launch Options:
      
      PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 VKD3D_CONFIG=dxr,dxr11 gamemoderun %command%
      
      # Alternative with more debugging (if still having issues):
      # PROTON_LOG=1 PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 DXVK_HUD=devinfo,fps VKD3D_CONFIG=dxr,dxr11 gamemoderun %command%
      
      # For Proton GE (if using protonup-qt):
      # Make sure to select Proton GE in Steam's compatibility settings
      # Recommended: GE-Proton9-20 or newer
    '';
    mode = "0644";
  };
}
