# modules/desktop/desktop-environments.nix - Multiple desktop environments configuration
{ config, pkgs, lib, ... }:

{
  # Keep KDE Plasma as default (already configured)
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Add GNOME (disabled by default, uncomment to enable)
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;  # GDM is GNOME's display manager
  
  # Add XFCE (lightweight, traditional desktop)
  # services.xserver.desktopManager.xfce.enable = true;
  
  # Add Cinnamon (GNOME 2-like experience)
  # services.xserver.desktopManager.cinnamon.enable = true;
  
  # Add MATE (another GNOME 2 fork)
  # services.xserver.desktopManager.mate.enable = true;
  
  # Add Budgie
  # services.xserver.desktopManager.budgie.enable = true;
  
  # Add Pantheon (Elementary OS desktop)
  # services.xserver.desktopManager.pantheon.enable = true;

  # Window Managers (can be used standalone or with a DE)
  
  # i3 (tiling window manager)
  # services.xserver.windowManager.i3 = {
  #   enable = true;
  #   package = pkgs.i3-gaps;
  #   extraPackages = with pkgs; [
  #     i3status
  #     i3lock
  #     i3blocks
  #     rofi
  #     polybar
  #   ];
  # };
  
  # Awesome WM
  # services.xserver.windowManager.awesome = {
  #   enable = true;
  #   luaModules = with pkgs.luaPackages; [
  #     vicious
  #   ];
  # };
  
  # Hyprland (Wayland compositor)
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };
  # # Optional: Add Hyprland utilities
  # environment.systemPackages = with pkgs; [
  #   waybar
  #   wofi
  #   mako
  #   swaylock
  #   swayidle
  #   grim
  #   slurp
  #   wl-clipboard
  # ];
  
  # Sway (i3-compatible Wayland compositor)
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [
  #     swaylock
  #     swayidle
  #     waybar
  #     wofi
  #     mako
  #     grim
  #     slurp
  #     wl-clipboard
  #   ];
  # };

  # COSMIC (System76's new Rust-based DE) - experimental
  # services.desktopManager.cosmic.enable = true;

  # Common packages for all desktop environments
  environment.systemPackages = with pkgs; [
    # Display manager themes
    # sddm-themes  # Additional SDDM themes if needed
    
    # Session management
    # lightdm  # Alternative display manager
    # lightdm-gtk-greeter
  ];

  # Note: To switch between desktop environments:
  # 1. Uncomment the desired desktop environment above
  # 2. Comment out conflicting display managers (can't have both SDDM and GDM)
  # 3. Run: sudo nixos-rebuild switch
  # 4. At login screen, select the desktop environment from the session menu
  
  # Tips:
  # - You can have multiple DEs installed simultaneously
  # - The display manager (SDDM/GDM/LightDM) provides the session selector
  # - SDDM works with all desktop environments
  # - Some combinations work better (GNOME+GDM, KDE+SDDM)
  # - Wayland sessions (Hyprland, Sway) work alongside X11 sessions
}