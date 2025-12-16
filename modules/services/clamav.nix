# modules/services/clamav.nix - ClamAV antivirus service with automatic updates
{ config, pkgs, lib, ... }:

{
  # ClamAV daemon service for real-time scanning
  services.clamav = {
    daemon = {
      enable = true;
      settings = {
        # Enable on-access scanning (real-time protection)
        OnAccessIncludePath = [
          "/home"
          "/tmp"
          "/var/tmp"
          "/opt"
        ];
        OnAccessExcludePath = [
          "${config.users.users.dom.home}/.cache"
          "${config.users.users.dom.home}/.local/share/Trash"
        ];
        OnAccessPrevention = false;  # Set to true for blocking, false for monitoring only
        OnAccessExtraScanning = true;  # Scan files opened for reading
        
        # Performance tuning
        MaxThreads = 4;
        MaxDirectoryRecursion = 15;
        
        # Logging
        LogFile = "/var/log/clamav/clamd.log";
        LogTime = true;
        LogClean = false;  # Don't log clean files
        LogVerbose = false;
        
        # Detection options
        DetectPUA = true;  # Detect Potentially Unwanted Applications
        HeuristicAlerts = true;
        AlertBrokenExecutables = true;
        AlertEncrypted = false;  # Don't alert on encrypted archives
        AlertOLE2Macros = true;  # Alert on Office macros
        
        # File size limits
        MaxFileSize = "100M";
        MaxScanSize = "300M";
      };
    };
    
    # Automatic virus database updates with freshclam
    updater = {
      enable = true;
      frequency = 12;  # Update every 12 hours
      interval = "hourly";  # Check hourly but respect frequency setting
      settings = {
        # Database mirror configuration
        DatabaseMirror = lib.mkDefault [
          "database.clamav.net"
          "db.local.clamav.net"
        ];
        
        # Update settings
        Checks = lib.mkDefault 2;  # Check for updates 2 times per day
        LogTime = lib.mkDefault true;
        LogVerbose = lib.mkDefault false;
        
        # Notification settings
        NotifyClamd = lib.mkDefault "/run/clamav/clamd.ctl";  # Notify daemon of updates
        
        # Connection settings
        ConnectTimeout = lib.mkDefault 30;
        ReceiveTimeout = lib.mkDefault 60;
      };
    };
  };
  
  # ClamTk GUI for ClamAV
  environment.systemPackages = with pkgs; [
    clamtk  # GTK-based GUI for ClamAV
    
    # Additional ClamAV utilities
    clamav  # Command-line scanner and tools
  ];
  
  # Create necessary directories and set permissions
  systemd.tmpfiles.rules = [
    "d /var/log/clamav 0755 clamav clamav -"
    "d /var/lib/clamav 0755 clamav clamav -"
  ];
  
  # Add user to clamav group for GUI access
  users.users.dom = {
    extraGroups = [ "clamav" ];
  };
  
  # Enable fanotify support for on-access scanning (requires root)
  security.unprivilegedUsernsClone = lib.mkDefault true;
  
  # Optional: Create a systemd service for scheduled scans
  systemd.services.clamav-scan-home = {
    description = "Scan home directory with ClamAV";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.clamav}/bin/clamscan -r /home --exclude-dir='^/home/[^/]+/.cache' --exclude-dir='^/home/[^/]+/.local/share/Trash' --log=/var/log/clamav/scheduled-scan.log --infected";
      User = "clamav";
      Group = "clamav";
    };
  };
  
  # Optional: Weekly scheduled scan timer
  systemd.timers.clamav-scan-home = {
    description = "Weekly ClamAV home directory scan";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };
  
  # Configure logrotate for ClamAV logs
  services.logrotate.settings.clamav = {
    files = [
      "/var/log/clamav/*.log"
    ];
    frequency = "weekly";
    rotate = 4;
    compress = true;
    delaycompress = true;
    missingok = true;
    notifempty = true;
    create = "644 clamav clamav";
    sharedscripts = true;
    postrotate = ''
      systemctl reload clamav-daemon 2>/dev/null || true
    '';
  };
}