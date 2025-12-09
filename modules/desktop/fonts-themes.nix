# modules/desktop/fonts-themes.nix - Fonts and themes configuration
{ pkgs, ... }:

{
  # Font packages
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      # Nerd Fonts (with icons/glyphs for terminals)
      # In NixOS 25.05, use the new nerd-fonts syntax
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      
      # Regular programming fonts (without nerd font patches)
      jetbrains-mono
      fira-code
      cascadia-code
      
      # System fonts
      liberation_ttf      # Free alternatives to Arial, Times New Roman
      noto-fonts          # Google's font family
      noto-fonts-cjk-sans # Chinese, Japanese, Korean
      noto-fonts-color-emoji    # Emoji support
      font-awesome        # Icon font
      
      # Additional quality fonts
      inter               # Excellent UI font
      roboto              # Google's material design font
      ubuntu-classic      # Ubuntu fonts
      source-sans-pro     # Adobe's sans font
      source-serif-pro    # Adobe's serif font
      
      # Terminal and coding focused
      victor-mono         # Cursive italics
      julia-mono          # Designed for Julia
      ibm-plex            # IBM's font family
      recursive           # Variable font with many styles
    ];
    
    # Font configuration
    fontconfig = {
      enable = true;
      
      defaultFonts = {
        serif = [ "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "Inter" "Noto Sans" "Liberation Sans" ];
        monospace = [ "JetBrains Mono" "Fira Code" ];
        emoji = [ "Noto Color Emoji" ];
      };
      
      # Improve font rendering
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };
  
  # GTK themes
  environment.systemPackages = with pkgs; [
    # Popular dark themes
    dracula-theme
    catppuccin-gtk
    nordic
    arc-theme
    materia-theme
    gruvbox-dark-gtk
    
    # Icon themes
    papirus-icon-theme
    dracula-icon-theme
    numix-icon-theme-circle
    tela-icon-theme
    
    # Cursor themes
    catppuccin-cursors
    bibata-cursors
    capitaine-cursors
  ];
  
  # Note: GNOME theme configuration would require dconf module
  # For now, themes can be set manually or through GNOME settings
  # programs.dconf would need home-manager or additional configuration
  
  # Note: Kitty terminal configuration would require home-manager
  # Can be configured per-user or system-wide with additional setup
  
  # VS Code theme will use extensions already configured
  # Additional VS Code themes can be added in development/tools.nix
  
  # Shell prompt themes - Starship can be enabled system-wide
  # Note: This is a basic starship configuration
  # More advanced configuration would require home-manager or per-user setup
}