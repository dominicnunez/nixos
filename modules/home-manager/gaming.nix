# modules/home-manager/gaming.nix - Gaming configuration
{ config, pkgs, lib, ... }:

{
  # Gaming packages
  home.packages = with pkgs; [
    # ===== Game Launchers =====
    lutris
    heroic
    bottles
    
    # ===== Gaming Tools =====
    protontricks
    winetricks
    
    # ===== Performance Tools =====
    mangohud
    goverlay  # GUI for MangoHud
    gamemode
    
    # ===== Controller Support =====
    jstest-gtk  # Joystick testing GUI
    antimicrox  # Controller mapping
    sc-controller  # Steam Controller configuration
    
    # ===== Emulators =====
    retroarch
    dolphin-emu
    # pcsx2  # PlayStation 2
    # rpcs3  # PlayStation 3
    # yuzu  # Nintendo Switch (if available)
    # ryujinx  # Nintendo Switch alternative
    # cemu  # Wii U
    # duckstation  # PlayStation 1
    
    # ===== Mod Managers =====
    r2modman  # Unity mod manager
    # nexusmods-app  # Nexus Mods app (when available)
    
    # ===== Utilities =====
    steamtinkerlaunch  # Steam Tinker Launch
    protonup-qt  # Manage Proton versions
    wine-staging
    wine64
    
    # ===== Discord with gaming features =====
    # discord is already in applications.nix
    
    # ===== Game Recording/Streaming =====
    # obs-studio  # Uncomment if you want streaming
    # gpu-screen-recorder  # Efficient GPU recording
  ];
  
  # MangoHud configuration
  home.file.".config/MangoHud/MangoHud.conf".text = ''
    # MangoHud configuration
    
    # Position and layout
    position=top-left
    width=350
    offset_x=10
    offset_y=10
    no_display=0
    toggle_hud=Shift_R+F12
    toggle_fps_limit=Shift_L+F1
    
    # Display options
    legacy_layout=false
    gpu_stats
    gpu_temp
    gpu_power
    gpu_load_change
    gpu_load_value=50,90
    gpu_load_color=FFFFFF,FF7800,CC0000
    gpu_text=GPU
    
    cpu_stats
    cpu_temp
    cpu_power
    cpu_load_change
    core_load
    cpu_load_value=50,90
    cpu_load_color=FFFFFF,FF7800,CC0000
    cpu_color=2E97CB
    cpu_text=CPU
    
    # Memory
    vram
    vram_color=AD64C1
    ram
    ram_color=C26693
    
    # FPS
    fps
    fps_limit=0
    fps_value=30,60
    fps_color=B8BB26,FB4934,CC241D
    frametime
    frame_timing
    
    # Other metrics
    gamemode
    vkbasalt
    engine_version
    vulkan_driver
    wine
    
    # Visual settings
    font_size=22
    font_scale=1.0
    background_alpha=0.5
    alpha=1.0
    round_corners=10
    
    # Keybindings
    toggle_logging=Shift_L+F2
    reload_cfg=Shift_L+F4
    upload_log=Shift_L+F3
  '';
  
  # Lutris configuration
  home.file.".config/lutris/lutris.conf".text = ''
    [lutris]
    library_ignores = 
    migration_version = 14
    show_advanced_options = True
    width = 1200
    height = 800
    window_x = 100
    window_y = 100
    maximized = False
    
    [list view]
    name_column_width = 200
    year_column_width = 60
    runner_column_width = 120
    platform_column_width = 120
    lastplayed_column_width = 120
    
    [services]
    lutris = True
    gog = True
    egs = True
    ubisoft = True
    steam = True
  '';
  
  # Heroic Games Launcher configuration
  home.file.".config/heroic/config.json".text = builtins.toJSON {
    defaultSettings = {
      defaultInstallPath = "/home/aural/Games/Heroic";
      defaultWinePrefix = "/home/aural/Games/Heroic/prefixes";
      checkForUpdatesOnStartup = false;
      addDesktopShortcuts = true;
      addStartMenuShortcuts = false;
      minimizeOnGameLaunch = true;
      showFps = true;
      enableMangoHud = true;
      audioFix = false;
      autoInstallDxvk = true;
      autoInstallVkd3d = true;
      preferSystemLibs = false;
      enableEsync = true;
      enableFsync = true;
      enableMsync = false;
      gameMode = true;
      showMangohud = true;
    };
    
    wineVersion = {
      type = "proton";
      name = "Proton-GE";
    };
  };
  
  # Bottles configuration
  home.file.".local/share/bottles/user.conf".text = ''
    [User]
    custom_bottles_path=/home/aural/Games/Bottles
    
    [Experiments]
    versioning=True
    installers=True
    snapshots=True
    
    [Performance]
    gamemode=True
    mangohud=True
    vkd3d=True
    dxvk=True
    
    [UI]
    dark_theme=True
    show_notifications=True
  '';
  
  # GameMode configuration (user-specific settings)
  home.file.".config/gamemode.ini".text = ''
    [general]
    ; The reaper thread will check every 5 seconds for exited clients
    reaper_freq=5
    
    ; GameMode can change the scheduler policy to SCHED_ISO on kernels which support it
    desiredgov=performance
    softrealtime=auto
    
    ; GameMode can renice your games to a lower value
    renice=10
    
    ; By default, GameMode adjusts the iopriority of clients to BE/0
    ioprio=0
    
    ; Disable split lock mitigation
    disable_splitlock=1
    
    [filter]
    ; Filter applications
    whitelist=steam;lutris;heroic;bottles;wine;retroarch
    
    [gpu]
    ; AMD GPU performance mode
    apply_gpu_optimisations=accept-responsibility
    amd_performance_level=high
    
    [cpu]
    ; CPU governor
    park_cores=no
    pin_cores=yes
  '';
  
  # Steam configuration (user settings)
  # Note: Most Steam config is binary, but we can set launch options
  home.file.".local/share/Steam/steam_dev.cfg".text = ''
    # Steam developer configuration
    @nClientDownloadEnableHTTP2PlatformLinux 0
    @fDownloadRateImprovementToAddAnotherConnection 1.0
  '';
  
  # Controller configurations
  home.file.".config/antimicrox/antimicrox.conf".text = ''
    [General]
    DisplayNames=true
    ControllerMappingFile=gamecontrollerdb.txt
    LastControllerProfileDir=/home/aural/.config/antimicrox/profiles
    
    [Controllers]
    AutoLoadProfiles=true
    StartMinimized=false
  '';
  
  # Environment variables for gaming
  home.sessionVariables = {
    # Wine/Proton
    WINEPREFIX = "$HOME/.wine";
    WINEARCH = "win64";
    
    # Vulkan
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
    
    # Gaming performance
    GAMEMODE = "1";
    MANGOHUD = "1";
    
    # Steam
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";
    STEAM_RUNTIME = "1";
    
    # SDL
    SDL_VIDEODRIVER = "wayland,x11";
    
    # Proton
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
    PROTON_ENABLE_NGX_UPDATER = "1";
    PROTON_USE_VKD3D = "1";
  };
  
  # XDG associations for game launchers
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/steam" = ["steam.desktop"];
    "x-scheme-handler/lutris" = ["lutris.desktop"];
    "x-scheme-handler/heroic" = ["heroic.desktop"];
  };
}