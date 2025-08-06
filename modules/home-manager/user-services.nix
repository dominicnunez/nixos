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
    
    # Syncthing (if needed)
    # syncthing = {
    #   Unit = {
    #     Description = "Syncthing - Open Source Continuous File Synchronization";
    #     Documentation = "man:syncthing(1)";
    #     After = ["network.target"];
    #   };
    #   
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -no-restart -logflags=0";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     SuccessExitStatus = [3 4];
    #     RestartForceExitStatus = [3 4];
    #   };
    #   
    #   Install = {
    #     WantedBy = ["default.target"];
    #   };
    # };
    
    # Custom backup service (example)
    # backup-home = {
    #   Unit = {
    #     Description = "Backup home directory";
    #     Documentation = "man:rsync(1)";
    #   };
    #   
    #   Service = {
    #     Type = "oneshot";
    #     ExecStart = "${pkgs.rsync}/bin/rsync -av --delete $HOME/Documents/ $HOME/Backup/Documents/";
    #   };
    # };
  };
  
  # User systemd timers
  systemd.user.timers = {
    # Backup timer (example)
    # backup-home = {
    #   Unit = {
    #     Description = "Daily backup of home directory";
    #     Documentation = "man:systemd.timer(5)";
    #   };
    #   
    #   Timer = {
    #     OnCalendar = "daily";
    #     Persistent = true;
    #   };
    #   
    #   Install = {
    #     WantedBy = ["timers.target"];
    #   };
    # };
    
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
  
  # SSH agent is already configured in ssh.nix
  # services.ssh-agent is defined there
  
  # GPG agent configuration (if needed)
  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   pinentryFlavor = "qt";
  #   
  #   defaultCacheTtl = 1800;
  #   defaultCacheTtlSsh = 1800;
  #   maxCacheTtl = 7200;
  #   maxCacheTtlSsh = 7200;
  # };
  
  # Redshift/Gammastep for blue light filter
  # services.redshift = {
  #   enable = true;
  #   provider = "manual";
  #   latitude = 40.0;
  #   longitude = -74.0;
  #   
  #   temperature = {
  #     day = 5500;
  #     night = 3500;
  #   };
  #   
  #   settings = {
  #     redshift = {
  #       fade = 1;
  #       gamma = "0.8:0.7:0.8";
  #       adjustment-method = "randr";
  #     };
  #   };
  # };
  
  # Dunst notification daemon (if not using DE notifications)
  # services.dunst = {
  #   enable = true;
  #   
  #   settings = {
  #     global = {
  #       follow = "mouse";
  #       indicate_hidden = true;
  #       shrink = false;
  #       separator_height = 2;
  #       padding = 8;
  #       horizontal_padding = 8;
  #       frame_width = 2;
  #       frame_color = "#89b4fa";
  #       separator_color = "frame";
  #       font = "JetBrains Mono 10";
  #       line_height = 0;
  #       format = "<b>%s</b>\n%b";
  #       alignment = "left";
  #       show_age_threshold = 60;
  #       word_wrap = true;
  #       icon_position = "left";
  #       max_icon_size = 32;
  #       browser = "${pkgs.brave}/bin/brave";
  #       mouse_left_click = "close_current";
  #       mouse_middle_click = "do_action";
  #       mouse_right_click = "close_all";
  #     };
  #     
  #     urgency_low = {
  #       background = "#1e1e2e";
  #       foreground = "#cdd6f4";
  #       timeout = 10;
  #     };
  #     
  #     urgency_normal = {
  #       background = "#1e1e2e";
  #       foreground = "#cdd6f4";
  #       timeout = 10;
  #     };
  #     
  #     urgency_critical = {
  #       background = "#1e1e2e";
  #       foreground = "#cdd6f4";
  #       frame_color = "#f38ba8";
  #       timeout = 0;
  #     };
  #   };
  # };
}