# modules/desktop/gaming.nix - Gaming configuration with Steam
{ pkgs, config, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true;  # For Steam game servers
  };

  # System-level gaming packages
  # Note: User gaming tools (launchers, emulators, etc.) are in home-manager/gaming.nix
  environment.systemPackages = with pkgs; [
    # Steam and runtime tools
    steam
    steam-run          # Run non-Steam games in Steam runtime
    steamcmd           # Steam command-line tool

    # Wine for Windows games - System-level Wine runtime
    wineWowPackages.stagingFull  # Full staging with all features

    # DirectX and DXVK support (system libraries for gaming)
    dxvk               # DirectX to Vulkan translation layer
    dxvk_2            # DXVK 2.x for newer DirectX support
    vkd3d              # Direct3D 12 to Vulkan translation
    vkd3d-proton       # Proton's fork of VKD3D

    # Additional DirectX/Graphics libraries
    mesa-demos         # OpenGL/Mesa demos and tools
    vulkan-caps-viewer # Check Vulkan capabilities
    renderdoc          # Graphics debugger

    # Wine/Proton system dependencies
    cabextract         # Extract Windows cabinet files
    p7zip              # Archive support
    unzip              # ZIP support
    zenity             # GUI dialogs for Wine

    # System libraries that Wine/Proton might need
    gnutls             # TLS support
    openldap           # LDAP support
    libgpg-error       # GPG error handling
    sqlite             # Database support
    libxml2            # XML parsing
    libxslt            # XSLT support
    libkrb5            # Kerberos support
    pkgsi686Linux.gnutls  # 32-bit TLS support
    samba              # SMB/CIFS support (some games need this)

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
        spirv-cross          # SPIR-V cross compiler
        
        # VA-API support for video acceleration
        libva
        libva-utils
        
        # Mesa drivers for AMD GPUs with full acceleration
        mesa
        # mesa.drivers is deprecated, mesa includes drivers now
        
        # GPU-specific acceleration packages are in gpu-acceleration.nix
        
        # Additional video acceleration
        libva-vdpau-driver
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
        # Performance level is auto-managed by AMD drivers
      };
      
      cpu = {
        park_cores = "no";
        pin_query = "yes";
      };
    };
  };

  # Add user to required groups
  users.users.dom = {
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
    vista-fonts        # Windows Vista fonts
  ];
  
  # System-level Wine/Proton configuration for Path of Exile 2
  environment.variables = {
    # Steam runtime configuration
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";  # Use Steam runtime libs
    STEAM_RUNTIME = "1";                        # Enable Steam runtime
    
    # Path of Exile 2 specific fixes
    PROTON_NO_ESYNC = "0";     # Enable ESYNC for better performance
    PROTON_NO_FSYNC = "0";     # Enable FSYNC if kernel supports it
    
    # DirectX factory fixes - CRITICAL FOR POE2
    DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk"; # DXVK cache location
    
    # Wine prefix configuration
    WINEPREFIX = "$HOME/.wine";  # Default Wine prefix location
    WINEARCH = "win64";          # Use 64-bit Wine architecture
    
    # Shader cache settings
    __GL_SHADER_DISK_CACHE = "1";      # Enable shader disk cache
    __GL_SHADER_DISK_CACHE_PATH = "$HOME/.cache/mesa_shader_cache"; # Mesa shader cache path
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
  
  # Create helper scripts for Path of Exile 2
  environment.etc."poe2-launch-options.txt" = {
    text = ''
      # Path of Exile 2 Steam Launch Options (AMD GPU)
      # Copy this line to Steam -> Path of Exile 2 -> Properties -> Launch Options:

      AMD_VULKAN_ICD=RADV DXVK_ASYNC=1 VKD3D_CONFIG=dxr,dxr11 WINE_FULLSCREEN_FSR=1 gamemoderun %command% --nologo --waitforpreload

      # Alternative for DirectX factory error fix (USE THIS IF ERROR PERSISTS):
      AMD_VULKAN_ICD=RADV PROTON_USE_WINED3D=0 DXVK_ASYNC=1 VKD3D_CONFIG=dxr,dxr11 DXVK_STATE_CACHE=1 __GL_SHADER_DISK_CACHE=1 gamemoderun %command% --nologo --waitforpreload -dx11

      # Debug mode (if still having issues):
      # PROTON_LOG=1 DXVK_LOG_LEVEL=info AMD_VULKAN_ICD=RADV DXVK_ASYNC=1 DXVK_HUD=devinfo,fps,version,api VKD3D_CONFIG=dxr,dxr11 gamemoderun %command%

      # For Proton GE (recommended for PoE2):
      # 1. Use protonup-qt to install GE-Proton9-20 or newer
      # 2. In Steam, right-click PoE2 -> Properties -> Compatibility
      # 3. Force compatibility tool: GE-Proton9-20
      # 4. Use the launch options above

      # IMPORTANT: If you get createdxgifactor1 error:
      # 1. Delete the game's shader cache: rm -rf ~/.steam/steam/steamapps/shadercache/2694490/
      # 2. Delete DXVK cache: rm -rf ~/.cache/dxvk/
      # 3. Verify game files in Steam
      # 4. Try adding -dx11 or -vulkan to the launch options
    '';
    mode = "0644";
  };
  
  # Create a PoE2 fix script
  environment.etc."poe2-fix.sh" = {
    text = ''
      #!/usr/bin/env bash
      echo "========================================"
      echo "Path of Exile 2 DirectX Fix Script"
      echo "========================================"
      echo ""

      # Check for AMD GPU
      if lspci | grep -i amd > /dev/null || lspci | grep -i radeon > /dev/null; then
        echo "✓ AMD GPU detected"
      else
        echo "⚠ Warning: No AMD GPU detected. This script is optimized for AMD."
      fi

      # Check Vulkan support
      echo ""
      echo "Checking Vulkan support..."
      if command -v vulkaninfo &> /dev/null; then
        if vulkaninfo --summary 2>/dev/null | grep -qi "radv\|amd"; then
          echo "✓ AMD RADV Vulkan driver is available"
        else
          echo "⚠ AMD Vulkan driver not detected!"
        fi
      fi

      # Clear shader caches
      echo ""
      echo "Clearing shader caches..."
      rm -rf ~/.steam/steam/steamapps/shadercache/2694490/ 2>/dev/null
      rm -rf ~/.cache/dxvk/ 2>/dev/null
      rm -rf ~/.cache/mesa_shader_cache/ 2>/dev/null
      rm -rf ~/.steam/steam/steamapps/compatdata/2694490/pfx/drive_c/users/*/AppData/Local/Path\ of\ Exile\ 2/DirectXCache/ 2>/dev/null
      echo "✓ Shader caches cleared"

      # Create necessary directories
      mkdir -p ~/.cache/dxvk
      mkdir -p ~/.cache/mesa_shader_cache
      echo "✓ Cache directories created"
      
      # Set up Wine prefix if needed
      export WINEPREFIX="$HOME/.steam/steam/steamapps/compatdata/2694490/pfx"
      if [ -d "$WINEPREFIX" ]; then
        echo ""
        echo "Setting up DirectX components in Wine prefix..."
        echo "(This may take a moment)"
        
        # Install DirectX dependencies
        WINEPREFIX="$WINEPREFIX" winetricks -q d3dx9 d3dcompiler_43 d3dcompiler_47 d3dx11_43 2>/dev/null
        
        # Set Windows version to Windows 10
        WINEPREFIX="$WINEPREFIX" winecfg -v win10 2>/dev/null
        
        echo "✓ DirectX components installed"
      else
        echo ""
        echo "⚠ PoE2 Wine prefix not found. Please run the game once first."
      fi
      
      echo ""
      echo "========================================"
      echo "Fix applied successfully!"
      echo "========================================"
      echo ""
      echo "Next steps:"
      echo "1. Open Steam"
      echo "2. Right-click Path of Exile 2 → Properties → Installed Files"
      echo "3. Click 'Verify integrity of game files'"
      echo "4. Go to Properties → Compatibility"
      echo "5. Enable 'Force the use of a specific Steam Play compatibility tool'"
      echo "6. Select 'Proton GE' (install via protonup-qt if not available)"
      echo "7. Go to Properties → General → Launch Options"
      echo "8. Add this (all one line):"
      echo ""
      echo "AMD_VULKAN_ICD=RADV PROTON_USE_WINED3D=0 DXVK_ASYNC=1 VKD3D_CONFIG=dxr,dxr11 DXVK_STATE_CACHE=1 __GL_SHADER_DISK_CACHE=1 gamemoderun %command% --nologo --waitforpreload -dx11"
      echo ""
      echo "9. If the error persists, try adding -vulkan instead of -dx11"
      echo ""
      echo "For more options, see: /etc/poe2-launch-options.txt"
    '';
    mode = "0755";
  };
}
