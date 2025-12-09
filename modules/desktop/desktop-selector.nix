# modules/desktop/desktop-selector.nix - Easy desktop environment switching
{ config, pkgs, lib, ... }:

let
  # Configure which desktop environments to enable
  # Change these to true to enable, false to disable
  desktopConfig = {
    # Full Desktop Environments
    plasma = true;      # KDE Plasma (currently enabled)
    gnome = false;      # GNOME
    xfce = true;        # XFCE - re-enabled, will configure to work with KDE
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
  services.displayManager.gdm.enable = desktopConfig.useGdm;
  services.displayManager.lightdm.enable = desktopConfig.useLightdm;

  # Desktop Environments
  services.desktopManager.plasma6.enable = desktopConfig.plasma;  # NixOS 25.11 uses Plasma 6
  services.desktopManager.gnome.enable = desktopConfig.gnome;
  services.desktopManager.xfce.enable = desktopConfig.xfce;
  # Cinnamon and Budgie still use services.xserver.desktopManager in 25.11
  services.xserver.desktopManager.cinnamon.enable = desktopConfig.cinnamon;
  services.xserver.desktopManager.mate.enable = desktopConfig.mate;
  services.xserver.desktopManager.budgie.enable = desktopConfig.budgie;
  services.desktopManager.pantheon.enable = desktopConfig.pantheon;
  
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
    
    # Fix breeze theme package collisions between Qt5 and Qt6 versions
    # This collision occurs when Plasma 6 (Qt6) and some Qt5 apps both try to install breeze themes
    (lib.optionals desktopConfig.plasma [
      # Explicitly prioritize Qt6 breeze packages to resolve conflicts
      (lib.hiPrio kdePackages.breeze-icons)
      (lib.hiPrio kdePackages.breeze-gtk)
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
  
  # XDG portal configuration for Wayland compositors and screen recording
  xdg.portal = {
    enable = desktopConfig.hyprland || desktopConfig.sway || desktopConfig.plasma;
    extraPortals = with pkgs; lib.flatten [
      (lib.optionals (desktopConfig.hyprland || desktopConfig.sway) [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ])
      (lib.optionals desktopConfig.plasma [
        kdePackages.xdg-desktop-portal-kde  # Required for screen recording in KDE
      ])
    ];
  };
  
  # Exclude XFCE notification daemon when both KDE and XFCE are enabled
  # This prevents notification conflicts and ensures KDE notifications work properly
  environment.xfce.excludePackages = lib.mkIf (desktopConfig.plasma && desktopConfig.xfce) [
    pkgs.xfce.xfce4-notifyd
  ];

  
  # Ensure KDE notification service takes priority when both are installed
  systemd.user.services.ensure-kde-notifications = lib.mkIf (desktopConfig.plasma && desktopConfig.xfce) {
    description = "Ensure KDE notifications are used instead of XFCE";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p ~/.local/share/dbus-1/services/ && ln -sf /run/current-system/sw/share/dbus-1/services/org.kde.plasma.Notifications.service ~/.local/share/dbus-1/services/org.freedesktop.Notifications.service'";
    };
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