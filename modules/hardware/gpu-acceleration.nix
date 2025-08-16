# modules/hardware/gpu-acceleration.nix - Hardware acceleration configuration
{ config, pkgs, lib, ... }:

{
  # Enable NVIDIA proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # NVIDIA driver configuration
  hardware.nvidia = {
    # Modesetting is required for most Wayland compositors
    modesetting.enable = true;
    
    # Use the open source kernel module (only for newer GPUs)
    # RTX 4080 Super supports this
    open = false;  # Set to true if you want to try the open kernel module
    
    # Enable the nvidia settings GUI
    nvidiaSettings = true;
    
    # Select the driver package (stable, beta, or specific version)
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # Power management (can cause issues, disable if you have problems)
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };
  
  # Enable full hardware acceleration for desktop and applications
  hardware = {
    # Graphics configuration
    graphics = {
      enable = true;
      enable32Bit = true;
      
      # GPU acceleration packages for NVIDIA
      extraPackages = with pkgs; [
        # Core acceleration
        mesa
        
        # Vulkan support
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        
        # NVIDIA Vulkan ICD - CRITICAL for Steam/Proton
        # The NVIDIA driver is already included via services.xserver.videoDrivers
        
        # Video acceleration APIs
        libva
        libva-utils
        nvidia-vaapi-driver  # NVIDIA VA-API driver
        vaapiVdpau
        libvdpau
        
        # Additional tools
        libdrm
        glxinfo
      ];
      
      # 32-bit support for compatibility
      extraPackages32 = with pkgs.pkgsi686Linux; [
        mesa
        libva
        libvdpau
        # NVIDIA 32-bit support is handled automatically
      ];
    };
    
    # Enable firmware updates for GPU
    enableRedistributableFirmware = true;
  };
  
  # Environment variables for optimal NVIDIA GPU performance
  environment.variables = {
    # NVIDIA GPU configuration
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    
    # Enable hardware acceleration
    LIBGL_DRI3_ENABLE = "1";
    
    # Video acceleration for NVIDIA
    VDPAU_DRIVER = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    
    # Vulkan configuration - Let the system auto-detect
    # VK_ICD_FILENAMES is set automatically by NixOS
    
    # Wine/Proton DirectX compatibility (fixes createdxgifactor1 error)
    PROTON_ENABLE_NVAPI = "1";      # Enable NVIDIA API support in Proton
    PROTON_HIDE_NVIDIA_GPU = "0";   # Don't hide NVIDIA GPU from games
    DXVK_ASYNC = "1";               # Enable async shader compilation
    VKD3D_CONFIG = "dxr11,dxr";     # Enable DirectX Raytracing support
    WINE_CPU_TOPOLOGY = "4:2";      # Optimize Wine CPU topology
    __NV_PRIME_RENDER_OFFLOAD = "1"; # Enable PRIME render offload
    
    # Enable vsync to prevent tearing
    __GL_SYNC_TO_VBLANK = "1";
    __GL_GSYNC_ALLOWED = "1";
    
    # Compositor hints
    KWIN_TRIPLE_BUFFER = "1";  # For KDE Plasma
    CLUTTER_PAINT = "disable-clipped-redraws:disable-culling";
    
    # CUDA support
    CUDA_CACHE_DISABLE = "0";
    
    # Wayland support for NVIDIA (if using Wayland)
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix cursor issues on Wayland
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
  };
  
  # Kernel modules for NVIDIA GPU
  boot = {
    # Load NVIDIA modules early
    initrd.kernelModules = [ ];
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    
    # Kernel parameters for NVIDIA GPU optimization
    kernelParams = [
      # NVIDIA GPU features
      "nvidia-drm.modeset=1"              # Enable kernel modesetting
      "nvidia-drm.fbdev=1"                # Framebuffer device
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Preserve memory for suspend
      
      # Performance and compatibility
      "iommu=pt"                          # IOMMU passthrough mode
      "pcie_aspm=off"                     # Disable PCIe power saving
      
      # Prevent nouveau from loading
      "nouveau.modeset=0"
    ];
    
    # Blacklist nouveau driver to ensure nvidia is used
    blacklistedKernelModules = [ "nouveau" ];
    
    # Extra module packages
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
  
  # X11 configuration for NVIDIA GPU performance
  services.xserver = {
    # Device section for X11 config
    deviceSection = ''
      Option "DRI" "3"
      Option "AccelMethod" "none"
      Option "TearFree" "false"  # NVIDIA handles this differently
    '';
    
    # Screen section for compositing and G-Sync
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, AllowGSYNC=On}"
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';
    
    # Server flags for better performance
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };
  
  # Power management for GPU
  powerManagement = {
    # Enable power management
    enable = true;
    
    # CPU frequency governor
    cpuFreqGovernor = lib.mkDefault "performance";
  };
  
  # System packages for GPU monitoring and control
  environment.systemPackages = with pkgs; [
    # GPU monitoring
    nvtopPackages.nvidia  # NVIDIA GPU process monitor
    # nvidia-system-monitor-qt  # GUI system monitor (optional)
    
    # OpenGL testing
    glxinfo
    glmark2
    
    # Vulkan testing
    vulkan-tools
    
    # Video info
    vdpauinfo
    libva-utils
    
    # NVIDIA specific tools
    # nvidia-settings is provided by hardware.nvidia.nvidiaSettings
    nvitop  # Interactive NVIDIA GPU monitor
    
    # System utilities
    pciutils  # For lspci
    lshw  # Hardware lister
  ];
  
  # Services for GPU management
  services = {
    # Enable thermald for better thermal management
    thermald.enable = true;
    
    # ACPI event daemon for power management
    acpid.enable = true;
  };
}