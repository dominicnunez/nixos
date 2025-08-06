# modules/desktop/desktop-selector.nix - Easy desktop environment switching
{ config, pkgs, lib, ... }:

let
  # Configure which desktop environments to enable
  # Change these to true to enable, false to disable
  desktopConfig = {
    # Full Desktop Environments
    plasma = true;      # KDE Plasma (currently enabled)
    gnome = false;      # GNOME
    xfce = true;        # XFCE - lightweight option enabled for testing
    cinnamon = false;   # Cinnamon
    mate = false;       # MATE
    budgie = false;     # Budgie
    pantheon = false;   # Pantheon
    
    # Window Managers
    i3 = false;         # i3 tiling WM
    awesome = false;    # Awesome WM
    hyprland = false;   # Hyprland (Wayland)
    sway = false;       # Sway (Wayland)
    
    # Display Manager
    # Only one should be true
    useSddm = true;     # KDE's display manager (works with all)
    useGdm = false;     # GNOME's display manager
    useLightdm = false; # Lightweight display manager
  };
in
{
  # Display Manager Configuration
  services.displayManager.sddm.enable = desktopConfig.useSddm;
  services.xserver.displayManager.gdm.enable = desktopConfig.useGdm;
  services.xserver.displayManager.lightdm.enable = desktopConfig.useLightdm;
  
  # Desktop Environments
  services.desktopManager.plasma6.enable = desktopConfig.plasma;
  services.xserver.desktopManager.gnome.enable = desktopConfig.gnome;
  services.xserver.desktopManager.xfce.enable = desktopConfig.xfce;
  services.xserver.desktopManager.cinnamon.enable = desktopConfig.cinnamon;
  services.xserver.desktopManager.mate.enable = desktopConfig.mate;
  services.xserver.desktopManager.budgie.enable = desktopConfig.budgie;
  services.xserver.desktopManager.pantheon.enable = desktopConfig.pantheon;
  
  # Window Managers
  services.xserver.windowManager.i3 = lib.mkIf desktopConfig.i3 {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      i3status
      i3lock
      i3blocks
      rofi
      polybar
      dmenu
      dunst
      picom
      nitrogen
      xss-lock
    ];
  };
  
  services.xserver.windowManager.awesome = lib.mkIf desktopConfig.awesome {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      vicious
    ];
  };
  
  programs.hyprland = lib.mkIf desktopConfig.hyprland {
    enable = true;
    xwayland.enable = true;
  };
  
  programs.sway = lib.mkIf desktopConfig.sway {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      waybar
      wofi
      mako
      grim
      slurp
      wl-clipboard
    ];
  };
  
  # Additional packages based on what's enabled
  environment.systemPackages = with pkgs; lib.flatten [
    # GNOME extras
    (lib.optionals desktopConfig.gnome [
      gnome-tweaks
      gnome-themes-extra
      gnome-extensions-cli
    ])
    
    # XFCE extras
    (lib.optionals desktopConfig.xfce [
      xfce.xfce4-whiskermenu-plugin
      xfce.xfce4-pulseaudio-plugin
      xfce.xfce4-clipman-plugin
    ])
    
    # Hyprland extras
    (lib.optionals desktopConfig.hyprland [
      waybar
      wofi
      mako
      swaylock-effects
      swayidle
      grim
      slurp
      wl-clipboard
      swww  # Wallpaper daemon
      kitty # Terminal that works well with Wayland
    ])
    
    # Common tools for all environments
    (lib.optionals (desktopConfig.gnome || desktopConfig.xfce || desktopConfig.cinnamon || desktopConfig.mate) [
      networkmanagerapplet
    ])
  ];
  
  # Wayland support
  environment.sessionVariables = lib.mkIf (desktopConfig.hyprland || desktopConfig.sway) {
    # Hint Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    
    # Firefox Wayland support
    MOZ_ENABLE_WAYLAND = "1";
    
    # QT Wayland support
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # SDL Wayland support
    SDL_VIDEODRIVER = "wayland";
  };
  
  # XDG portal configuration for Wayland compositors
  xdg.portal = lib.mkIf (desktopConfig.hyprland || desktopConfig.sway) {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}

# Instructions:
# 1. Edit the desktopConfig at the top of this file
# 2. Set desired desktop environments to true
# 3. Make sure only one display manager is true
# 4. Save and run: sudo nixos-rebuild switch
# 5. Restart and select your desktop at the login screen

# Note: You can have multiple desktop environments installed at once.
# The display manager will show a session selector to choose between them.