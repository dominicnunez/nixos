# modules/desktop/fonts-themes.nix - Fonts and themes configuration
{ pkgs, ... }:

{
  # Font packages
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      # Nerd Fonts (with icons/glyphs for terminals)
      (nerdfonts.override { 
        fonts = [ 
          "JetBrainsMono"     # Most popular for coding
          "FiraCode"          # Popular with ligatures
          "Hack"              # Clean and simple
          "CascadiaCode"      # Microsoft's modern font
          "Meslo"             # Popular with oh-my-zsh
          "SourceCodePro"     # Adobe's coding font
          "RobotoMono"        # Google's mono font
          "UbuntuMono"        # Ubuntu's mono font
          "Iosevka"           # Highly customizable
          "Terminus"          # Bitmap font for terminals
        ]; 
      })
      
      # Regular programming fonts (without nerd font patches)
      jetbrains-mono
      fira-code
      cascadia-code
      
      # System fonts
      liberation_ttf      # Free alternatives to Arial, Times New Roman
      noto-fonts          # Google's font family
      noto-fonts-cjk      # Chinese, Japanese, Korean
      noto-fonts-emoji    # Emoji support
      font-awesome        # Icon font
      
      # Additional quality fonts
      inter               # Excellent UI font
      roboto              # Google's material design font
      ubuntu_font_family  # Ubuntu fonts
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
        monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" ];
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
  
  # GNOME theme configuration
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Dracula";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Catppuccin-Mocha-Dark";
        font-name = "Inter 11";
        document-font-name = "Inter 11";
        monospace-font-name = "JetBrainsMono Nerd Font 11";
      };
      
      "org/gnome/desktop/wm/preferences" = {
        titlebar-font = "Inter Bold 11";
      };
      
      "org/gnome/shell/extensions/user-theme" = {
        name = "Dracula";
      };
    };
  }];
  
  # Terminal themes (for Kitty)
  programs.kitty.theme = "Dracula";
  
  # VS Code theme will use extensions already configured
  # Additional VS Code themes can be added in development/tools.nix
  
  # Shell prompt themes (already configured with starship)
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [╭─$username$hostname$directory$git_branch$git_status$nodejs$python$golang$docker_context$kubernetes]($style)
        [╰─$character]($style) 
      '';
      
      username = {
        show_always = true;
        style_user = "fg:#9147ff";
        style_root = "fg:#ff4444";
        format = "[$user]($style)";
      };
      
      hostname = {
        ssh_only = false;
        style = "fg:#00b4d8";
        format = "[@$hostname]($style) ";
      };
      
      directory = {
        style = "fg:#48cae4";
        truncation_length = 3;
        truncate_to_repo = false;
        format = "[$path]($style) ";
      };
      
      git_branch = {
        style = "fg:#81a1c1";
        symbol = " ";
        format = "[$symbol$branch]($style) ";
      };
      
      nodejs = {
        style = "fg:#43d426";
        symbol = " ";
        format = "[$symbol($version)]($style) ";
      };
      
      python = {
        style = "fg:#ffde57";
        symbol = " ";
        format = "[$symbol($version)]($style) ";
      };
      
      golang = {
        style = "fg:#00add8";
        symbol = " ";
        format = "[$symbol($version)]($style) ";
      };
      
      character = {
        success_symbol = "[❯](fg:#43d426)";
        error_symbol = "[❯](fg:#ff4444)";
      };
    };
  };
}