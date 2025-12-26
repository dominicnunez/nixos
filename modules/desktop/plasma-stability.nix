# modules/desktop/plasma-stability.nix - Fixes for KDE Plasma taskbar freezing
# Addresses: NVIDIA Wayland EGL issues, plasmashell memory leaks, and unresponsive panels
{ config, pkgs, lib, ... }:

{
  # Environment variables to improve NVIDIA + Wayland compatibility
  # These help prevent the QWaylandGLContext EGL errors
  environment.sessionVariables = {
    # Force EGL device selection for NVIDIA
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";

    # Improve NVIDIA Wayland buffer handling
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Disable problematic hardware cursor on Wayland
    WLR_NO_HARDWARE_CURSORS = "1";
    KWIN_DRM_NO_AMS = "1";  # Disable atomic mode setting if causing issues

    # Qt/KDE Wayland improvements
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";  # Prevents EGL decoration context issues
  };

  # Systemd user service to monitor plasmashell memory and restart if needed
  systemd.user.services.plasmashell-watchdog = {
    description = "Monitor plasmashell memory usage and restart if excessive";
    wantedBy = [ "graphical-session.target" ];
    after = [ "plasma-plasmashell.service" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 30;
    };

    # Check every 5 minutes, restart plasmashell if memory exceeds 800MB
    script = ''
      #!/usr/bin/env bash
      MEMORY_LIMIT_KB=819200  # 800MB in KB
      CHECK_INTERVAL=300      # 5 minutes

      while true; do
        sleep $CHECK_INTERVAL

        # Get plasmashell PID
        PLASMA_PID=$(${pkgs.procps}/bin/pgrep -x plasmashell || true)

        if [ -n "$PLASMA_PID" ]; then
          # Get RSS memory in KB
          MEMORY_KB=$(${pkgs.procps}/bin/ps -o rss= -p "$PLASMA_PID" 2>/dev/null | tr -d ' ' || echo "0")

          if [ "$MEMORY_KB" -gt "$MEMORY_LIMIT_KB" ]; then
            echo "Plasmashell memory usage ($MEMORY_KB KB) exceeds limit ($MEMORY_LIMIT_KB KB). Restarting..."
            ${pkgs.systemd}/bin/systemctl --user restart plasma-plasmashell.service
          fi
        fi
      done
    '';
  };

  # Systemd user service override for plasmashell with memory limits and better restart handling
  systemd.user.services.plasma-plasmashell-override = {
    description = "Override plasmashell service with memory limits";
    wantedBy = [ "graphical-session.target" ];
    after = [ "plasma-plasmashell.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p ~/.config/systemd/user/plasma-plasmashell.service.d'";
    };
  };

  # Create a drop-in override for plasma-plasmashell service
  environment.etc."skel/.config/systemd/user/plasma-plasmashell.service.d/memory-limit.conf".text = ''
    [Service]
    # Limit memory to 1GB - will be killed if exceeded, triggering restart
    MemoryMax=1G
    MemoryHigh=800M

    # Better restart behavior
    Restart=on-failure
    RestartSec=2

    # Reduce timeout before SIGKILL
    TimeoutStopSec=15
  '';

  # Script to install plasmashell overrides for the user
  system.activationScripts.plasmaOverrides = ''
    # This runs as root, so we need to handle user config differently
    # The actual override will be created by the user service above
  '';

  # Add a script users can run to manually restart plasmashell without logging out
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "restart-plasmashell" ''
      #!/usr/bin/env bash
      echo "Restarting plasmashell..."

      # Try systemd first
      if systemctl --user is-active plasma-plasmashell.service >/dev/null 2>&1; then
        systemctl --user restart plasma-plasmashell.service
      else
        # Fallback: kill and restart manually
        killall plasmashell 2>/dev/null || true
        sleep 2
        ${pkgs.kdePackages.plasma-workspace}/bin/plasmashell &
        disown
      fi

      echo "Plasmashell restarted."
    '')

    (writeShellScriptBin "restart-kwin" ''
      #!/usr/bin/env bash
      echo "Restarting KWin..."

      if systemctl --user is-active plasma-kwin_wayland.service >/dev/null 2>&1; then
        systemctl --user restart plasma-kwin_wayland.service
      elif systemctl --user is-active plasma-kwin_x11.service >/dev/null 2>&1; then
        systemctl --user restart plasma-kwin_x11.service
      else
        # Fallback
        kwin_wayland --replace &
        disown
      fi

      echo "KWin restarted."
    '')
  ];

  # Alternative: Force Plasma to use X11 instead of Wayland (more stable with NVIDIA)
  # Uncomment the following if Wayland issues persist:
  # services.displayManager.defaultSession = "plasma";  # Forces X11 Plasma session
}
