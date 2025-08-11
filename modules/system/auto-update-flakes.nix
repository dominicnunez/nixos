# modules/system/auto-update-flakes.nix - Automatic flake updates
{ config, pkgs, lib, ... }:

{
  # Systemd service to update flake inputs
  systemd.services.update-claude-code = {
    description = "Update claude-code flake input";
    path = [ pkgs.nix pkgs.git ];
    script = ''
      cd /home/aural/Code/nixos
      # Update only claude-code input
      nix flake update claude-code

      # Optional: Send notification if update is available
      if git diff --quiet flake.lock; then
        echo "No updates available for claude-code"
      else
        echo "claude-code update available! Run 'rebuild' to apply."
        # Optional: Send desktop notification
        ${pkgs.libnotify}/bin/notify-send "Claude Code Update" "New version available. Run 'rebuild' to apply." || true
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "aural";
    };
  };

  # Timer to run the update check daily
  systemd.timers.update-claude-code = {
    description = "Check for claude-code updates daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Run daily at 10 AM
      OnCalendar = "daily";
      # Also run 5 minutes after boot if missed
      Persistent = true;
      # Randomize by up to 1 hour to avoid thundering herd
      RandomizedDelaySec = "1h";
    };
  };

  # Optional: Service to auto-rebuild if updates are found (disabled by default)
  systemd.services.auto-rebuild-claude-code = {
    description = "Auto rebuild system if claude-code updates";
    path = [ pkgs.nix pkgs.git pkgs.nixos-rebuild ];
    script = ''
      cd /home/aural/Code/nixos

      # Check if there are changes to flake.lock
      if ! git diff --quiet flake.lock; then
        echo "Updates found, rebuilding system..."

        # Create a backup tag before rebuilding
        git add flake.lock
        git commit -m "Auto-update: claude-code flake" || true

        # Rebuild the system
        sudo nixos-rebuild switch --flake /home/aural/Code/nixos

        # Notify user
        ${pkgs.libnotify}/bin/notify-send "System Updated" "claude-code has been updated and system rebuilt" || true
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Timer for auto-rebuild (disabled by default - uncomment to enable)
  # systemd.timers.auto-rebuild-claude-code = {
  #   description = "Auto rebuild if updates available";
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     # Run 30 minutes after the update check
  #     OnCalendar = "daily";
  #     Persistent = true;
  #   };
  # };
}
