# modules/desktop/steam-vulkan-fix.nix - Fix for Steam Vulkan/DirectX issues
{ config, pkgs, lib, ... }:

{
  # Create proper NVIDIA Vulkan ICD file
  environment.etc."vulkan/icd.d/nvidia_icd.x86_64.json" = {
    text = ''
      {
        "file_format_version" : "1.0.0",
        "ICD": {
          "library_path": "${config.hardware.nvidia.package}/lib/libGLX_nvidia.so.0",
          "api_version" : "1.3.303"
        }
      }
    '';
  };
  
  # Create 32-bit NVIDIA Vulkan ICD file
  environment.etc."vulkan/icd.d/nvidia_icd.i686.json" = {
    text = ''
      {
        "file_format_version" : "1.0.0",
        "ICD": {
          "library_path": "${config.hardware.nvidia.package.lib32}/lib/libGLX_nvidia.so.0",
          "api_version" : "1.3.303"
        }
      }
    '';
  };
  
  # Override Steam to not disable GPU
  programs.steam.package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      # Add any extra packages Steam needs
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
    extraLibraries = pkgs: with pkgs; [
      # Ensure proper graphics libraries are available
      vulkan-loader
      pipewire
    ];
  };
  
  # Steam environment fixes
  environment.sessionVariables = {
    # Force Steam to use discrete GPU
    DRI_PRIME = "1";
    
    # Steam specific fixes
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
    STEAM_RUNTIME_HEAVY = "1";
    
    # Disable Steam GPU workarounds
    DISABLE_VK_LAYER_VALVE_steam_overlay_1 = "0";
    DISABLE_VK_LAYER_VALVE_steam_fossilize_1 = "0";
    
    # Force enable GPU in Steam
    STEAM_DISABLE_GPU = "0";
    STEAM_ENABLE_GPU = "1";
  };
  
  # System-wide Vulkan configuration
  environment.variables = {
    # Vulkan driver selection
    VK_ICD_FILENAMES = lib.mkForce 
      "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    
    # 32-bit Vulkan support
    VK_ICD_FILENAMES_i686 = 
      "/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";
    
    # Disable other Vulkan drivers to prevent conflicts
    __EGL_VENDOR_LIBRARY_FILENAMES = 
      "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
    
    # OpenGL configuration
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    # Force NVIDIA GPU for all applications
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    
    # LibDRM fix for the warnings
    LIBGL_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
    LIBGL_DRIVERS_PATH_32 = "/run/opengl-driver-32/lib/dri";
  };
  
  # Create a Steam wrapper script that ensures GPU is enabled
  environment.etc."steam-gpu-fix.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Steam GPU Fix Wrapper
      
      # Unset any GPU disabling variables
      unset STEAM_DISABLE_GPU
      unset __GL_RENDERER_FORCE_SOFTWARE
      
      # Force GPU acceleration
      export STEAM_ENABLE_GPU=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json
      
      # Remove problematic flags from Steam
      STEAM_ARGS=$(echo "$@" | sed 's/--disable-gpu-compositing//g' | sed 's/--disable-gpu//g')
      
      # Launch Steam with proper GPU support
      exec /run/current-system/sw/bin/steam $STEAM_ARGS
    '';
    mode = "0755";
  };
  
  # Create desktop entry override for Steam
  environment.etc."applications/steam-gpu.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Steam (GPU Fixed)
      Comment=Application for managing and playing games on Steam
      Exec=/etc/steam-gpu-fix.sh %U
      Icon=steam
      Terminal=false
      Type=Application
      Categories=Network;FileTransfer;Game;
      MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
      Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
      PrefersNonDefaultGPU=true
      X-KDE-RunOnDiscreteGpu=true
    '';
  };
  
  # Ensure NVIDIA kernel modules are loaded
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  
  # Add udev rules for NVIDIA GPU
  services.udev.extraRules = ''
    # NVIDIA GPU
    KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidiactl c 195 255'"
    KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'for i in $$(seq 0 15); do mknod -m 666 /dev/nvidia$$i c 195 $$i; done'"
    KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm c 243 0'"
    KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm-tools c 243 1'"
  '';
  
  # Ensure proper permissions for GPU device files
  systemd.services.nvidia-device-permissions = {
    description = "Set NVIDIA device permissions";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''${pkgs.bash}/bin/bash -c '
        chmod 666 /dev/nvidia* 2>/dev/null || true
        chmod 666 /dev/dri/* 2>/dev/null || true
      ' '';
    };
  };
  
  # Add Vulkan validation layers for debugging
  environment.systemPackages = with pkgs; [
    vulkan-validation-layers
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-extension-layer
    
    # Tools for debugging GPU issues
    nvidia-system-monitor-qt
    nvtopPackages.nvidia
    glxinfo
    glmark2
    
    # Additional Steam/Proton dependencies
    mangohud
    gamemode
    gamescope
  ];
}