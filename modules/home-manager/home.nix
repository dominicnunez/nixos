# modules/home-manager/home.nix - User-specific Home Manager configuration
{ config, pkgs, lib, ... }:

{
  # Import additional modules
  imports = [
    ./neovim.nix
    ./terminal.nix
    ./ssh.nix
    ./tmux.nix
    ./development.nix
    ./applications.nix
    ./browsers.nix
    ./gaming.nix
    ./xdg.nix
    ./user-services.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aural";
  home.homeDirectory = "/home/aural";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Basic user packages (these will be available only to this user)
  home.packages = with pkgs; [
    # We'll add user-specific packages here as we migrate
    libnotify  # For notify-send command to test notifications
  ];

  # Basic configuration to start
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # KDE Plasma notification configuration
  # Configure notifications to appear in bottom right corner
  xdg.configFile."plasmanotifyrc" = {
    text = ''
      [DoNotDisturb]
      NotificationSounds=true
      WhenScreensMirrored=false
      
      [Notifications]
      CriticalAlwaysOnTop=true
      LowPriorityHistory=true  
      NormalAlwaysOnTop=false
      PopupMargin=10
      PopupPosition=BottomRight
      PopupScreen=@Point
      PopupTimeout=5000
      ShowInHistory=true
    '';
  };

  # Create test notification script
  home.file.".local/bin/test-notification" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Test notification script
      
      echo "Sending test notification..."
      notify-send "Test Notification" "This should appear in the bottom right corner" \
        --icon=dialog-information \
        --expire-time=5000
      
      echo "Sent! Check if it appeared in the bottom right corner."
      echo "You can also try:"
      echo "  - Critical: notify-send -u critical 'Critical' 'This is urgent'"
      echo "  - Low priority: notify-send -u low 'Low Priority' 'Not urgent'"
    '';
  };

  # Git configuration moved to development.nix

  # FZF configuration
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always {}'"
    ];
    
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # Atuin (better shell history)
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    
    settings = {
      auto_sync = false;
      sync_frequency = "0";
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  # Direnv integration
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}