# modules/hardware/gpu-acceleration.nix - AMD Vega Mobile GPU configuration
{ config, pkgs, lib, ... }:

{
  # Enable AMD GPU driver (amdgpu is the default for Vega)
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Load AMD kernel modules at boot
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable full hardware acceleration for desktop and applications
  hardware = {
    # AMD GPU configuration
    amdgpu = {
      initrd.enable = true;
    };

    # Graphics configuration
    graphics = {
      enable = true;
      enable32Bit = true;

      # GPU acceleration packages for AMD
      extraPackages = with pkgs; [
        # Core acceleration
        mesa

        # AMD Vulkan drivers
        amdvlk
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        vulkan-headers
        vulkan-extension-layer
        spirv-tools

        # Video acceleration for AMD (VA-API)
        libva
        libva-utils
        libvdpau-va-gl  # VDPAU via VA-API for AMD

        # Mesa VA-API driver for AMD
        mesa.drivers

        # DirectX compatibility libraries
        libglvnd           # GL dispatch library
        ocl-icd           # OpenCL ICD loader

        # ROCm OpenCL for AMD (optional, for compute)
        rocmPackages.clr
        rocmPackages.clr.icd

        # Additional tools
        libdrm
        mesa-demos
      ];

      # 32-bit support for compatibility
      extraPackages32 = with pkgs.pkgsi686Linux; [
        mesa
        libva
        libvdpau-va-gl
        vulkan-loader
        vulkan-validation-layers
        libglvnd
        ocl-icd
        pipewire
        libpulseaudio
        amdvlk
      ];
    };

    # Enable firmware updates for GPU
    enableRedistributableFirmware = true;
  };

  # Environment variables for optimal AMD GPU performance
  environment.variables = {
    # AMD GPU configuration
    AMD_VULKAN_ICD = "RADV";  # Use RADV (Mesa) Vulkan driver - better for gaming

    # Enable hardware acceleration
    LIBGL_DRI3_ENABLE = "1";

    # Video acceleration for AMD
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";

    # Vulkan configuration
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/implicit_layer.d:/run/opengl-driver/share/vulkan/explicit_layer.d";

    # Wine/Proton DirectX compatibility
    PROTON_USE_WINED3D = "0";       # Use DXVK instead of WineD3D
    DXVK_ASYNC = "1";               # Enable async shader compilation
    DXVK_STATE_CACHE = "1";         # Enable DXVK state cache
    DXVK_LOG_LEVEL = "none";        # Reduce log spam
    VKD3D_CONFIG = "dxr,dxr11";     # Enable DirectX Raytracing support
    VKD3D_DEBUG = "none";           # Disable VKD3D debug messages
    VKD3D_SHADER_MODEL = "6_6";     # Use latest shader model

    # DirectX factory fix
    WINEDLLOVERRIDES = "d3d11=n;d3d10core=n;d3d10_1=n;d3d10=n;dxgi=n;d3d9=n";
    WINE_LARGE_ADDRESS_AWARE = "1";

    # Additional DirectX settings
    WINE_VULKAN_NEGATIVE_MIP_BIAS = "1";

    # Enable vsync to prevent tearing
    __GL_SYNC_TO_VBLANK = "1";

    # AMD-specific performance settings
    RADV_PERFTEST = "gpl";  # Enable graphics pipeline library for faster shader compilation

    # Compositor hints
    KWIN_TRIPLE_BUFFER = "1";  # For KDE Plasma
    CLUTTER_PAINT = "disable-clipped-redraws:disable-culling";

    # Wayland support
    WLR_NO_HARDWARE_CURSORS = "0";  # AMD supports hardware cursors on Wayland
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
  };

  # Kernel configuration for AMD GPU
  boot = {
    kernelModules = [ "amdgpu" ];

    # Kernel parameters for AMD GPU optimization
    kernelParams = [
      # AMD GPU features
      "amdgpu.ppfeaturemask=0xffffffff"  # Enable all power features
      "amdgpu.dc=1"                       # Enable Display Core
      "amdgpu.dpm=1"                      # Enable Dynamic Power Management
      "amdgpu.audio=1"                    # Enable HDMI audio

      # Performance and compatibility
      "iommu=pt"                          # IOMMU passthrough mode
    ];

    # Blacklist radeon driver to ensure amdgpu is used (for older APUs)
    blacklistedKernelModules = [ "radeon" ];
  };

  # X11 configuration for AMD GPU performance
  services.xserver = {
    # Device section for X11 config
    deviceSection = ''
      Option "DRI" "3"
      Option "TearFree" "true"
      Option "VariableRefresh" "true"
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
    enable = true;
    cpuFreqGovernor = lib.mkDefault "performance";
  };

  # System packages for GPU monitoring and control
  environment.systemPackages = with pkgs; [
    # GPU monitoring for AMD
    nvtopPackages.amd  # AMD GPU process monitor
    radeontop          # AMD GPU utilization monitor

    # OpenGL testing
    mesa-demos
    glmark2

    # Vulkan testing
    vulkan-tools

    # Video info
    libva-utils

    # AMD specific tools
    lact  # Linux AMD GPU Controller (fan curves, overclocking)

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
