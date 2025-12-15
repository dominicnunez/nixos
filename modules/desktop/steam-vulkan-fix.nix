# modules/desktop/steam-vulkan-fix.nix - Steam Vulkan configuration for AMD GPU
{ config, pkgs, lib, ... }:

{
  # Override Steam with extra packages
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

  # System-wide Vulkan configuration for AMD
  environment.variables = lib.mkMerge [
    {
      # Use RADV (Mesa) Vulkan driver - best for gaming on AMD
      AMD_VULKAN_ICD = "RADV";

      # LibDRM fix for warnings
      LIBGL_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
      LIBGL_DRIVERS_PATH_32 = "/run/opengl-driver-32/lib/dri";
    }
  ];

  # Create a Steam wrapper script for AMD
  environment.etc."steam-gpu-fix.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Steam AMD GPU Wrapper

      # Unset any GPU disabling variables
      unset STEAM_DISABLE_GPU
      unset __GL_RENDERER_FORCE_SOFTWARE

      # Force GPU acceleration
      export STEAM_ENABLE_GPU=1
      export AMD_VULKAN_ICD=RADV

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

  # Ensure proper permissions for GPU device files
  systemd.services.amd-device-permissions = {
    description = "Set AMD GPU device permissions";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''${pkgs.bash}/bin/bash -c '
        chmod 666 /dev/dri/* 2>/dev/null || true
        chmod 666 /dev/kfd 2>/dev/null || true
      ' '';
    };
  };

  # AMD-specific system packages (avoiding duplicates)
  environment.systemPackages = with pkgs; [
    # These are already in gaming.nix/gpu-acceleration.nix:
    # vulkan-validation-layers, vulkan-tools, vulkan-loader
    # radeontop, nvtopPackages.amd, glmark2, mangohud, gamemode, gamescope
  ];
}
