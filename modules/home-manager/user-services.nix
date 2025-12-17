# modules/home-manager/user-services.nix - User systemd services and autostart
{ config, pkgs, lib, ... }:

{
  # User systemd services
  systemd.user.services = {
    # Clipboard manager
    copyq = {
      Unit = {
        Description = "CopyQ clipboard manager";
        Documentation = "man:copyq(1)";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session-pre.target"];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.copyq}/bin/copyq";
        Restart = "on-failure";
        RestartSec = 1;
      };
      
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
    
    # Flameshot screenshot tool
    flameshot = {
      Unit = {
        Description = "Flameshot screenshot tool";
        Documentation = "https://github.com/flameshot-org/flameshot";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session-pre.target"];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.flameshot}/bin/flameshot";
        Restart = "on-failure";
        RestartSec = 1;
      };
      
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };

  # User systemd timers
  systemd.user.timers = {

    # Clear cache timer
    clear-cache = {
      Unit = {
        Description = "Weekly cache cleanup";
      };
      
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
  
  # Cache cleanup service
  systemd.user.services.clear-cache = {
    Unit = {
      Description = "Clear user cache directories";
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "clear-cache" ''
        # Clear old cache files
        find ~/.cache -type f -atime +30 -delete 2>/dev/null || true
        
        # Clear thumbnail cache older than 30 days
        find ~/.cache/thumbnails -type f -mtime +30 -delete 2>/dev/null || true
        
        # Clear old trash files
        find ~/.local/share/Trash/files -type f -mtime +30 -delete 2>/dev/null || true
        find ~/.local/share/Trash/info -type f -mtime +30 -delete 2>/dev/null || true
        
        # Clear old journal logs
        journalctl --user --vacuum-time=7d 2>/dev/null || true
        
        echo "Cache cleanup completed"
      '';
    };
  };
  
  # Session targets
  systemd.user.targets = {
    # Custom target for user applications
    user-applications = {
      Unit = {
        Description = "User Application Services";
        Documentation = "man:systemd.special(7)";
        StopWhenUnneeded = false;
      };
    };
  };
  
  # Autostart applications using systemd
  home.activation = {
    # Start enabled services (systemd reload is handled by Home Manager)
    startServices = lib.hm.dag.entryAfter ["reloadServiceUnits"] ''
      # Start clipboard manager if in graphical session
      if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        systemctl --user start copyq.service || true
        systemctl --user start flameshot.service || true
      fi
    '';
  };
  
  # XDG autostart entries (alternative to systemd services)
  xdg.configFile = {
    # Discord autostart (disabled by default)
    "autostart/discord.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Discord
        Exec=${pkgs.discord}/bin/discord --start-minimized
        Hidden=true
        NoDisplay=false
        X-GNOME-Autostart-enabled=false
        X-KDE-autostart-after=panel
      '';
    };
    
    # Steam autostart (disabled by default)
    "autostart/steam.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Steam
        Exec=${pkgs.steam}/bin/steam -silent
        Hidden=true
        NoDisplay=false
        X-GNOME-Autostart-enabled=false
      '';
    };
    
    # VS Code autostart (disabled by default)
    "autostart/code.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Visual Studio Code
        Exec=${pkgs.vscode}/bin/code --no-sandbox
        Hidden=true
        NoDisplay=false
        X-GNOME-Autostart-enabled=false
      '';
    };
  };
  
  # Service environment variables
  systemd.user.sessionVariables = {
    # Add any environment variables needed by services
    # These will be available to all user services
  };
  
  # Ensure required directories exist
  home.file = {
    ".config/systemd/user/.keep".text = "";
    ".local/share/systemd/user/.keep".text = "";
  };
}