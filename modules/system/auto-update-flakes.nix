# modules/system/auto-update-flakes.nix - Automatic flake updates
{ config, pkgs, lib, ... }:

let
  # Check if Claude Code is managed by user profile or system
  updateScript = pkgs.writeShellScript "update-claude-code" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Function to get version
    get_version() {
      command -v claude >/dev/null 2>&1 && claude --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "not installed"
    }
    
    # Function to get latest available version
    get_latest_version() {
      ${pkgs.nix}/bin/nix run github:sadjow/claude-code-nix -- --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown"
    }
    
    CURRENT_VERSION=$(get_version)
    echo "Current Claude Code version: $CURRENT_VERSION"
    
    # Check if managed by user profile
    if ${pkgs.nix}/bin/nix profile list 2>/dev/null | grep -q claude-code; then
      echo "Claude Code is managed by user profile"
      
      # Update user profile
      ${pkgs.nix}/bin/nix profile upgrade claude-code-nix 2>/dev/null || \
        ${pkgs.nix}/bin/nix profile upgrade 0 2>/dev/null || \
        echo "Failed to upgrade user profile"
      
      NEW_VERSION=$(get_version)
      if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
        echo "Updated Claude Code in user profile: $CURRENT_VERSION -> $NEW_VERSION"
        ${pkgs.libnotify}/bin/notify-send -u normal "Claude Code Updated" "Version $NEW_VERSION installed (was $CURRENT_VERSION)" || true
      else
        echo "Claude Code is already up-to-date in user profile"
      fi
    else
      echo "Claude Code is managed by system configuration"
      
      # Update flake for system
      cd /home/dom/Code/nixos
      ${pkgs.nix}/bin/nix flake update claude-code
      
      if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
        LATEST_VERSION=$(get_latest_version)
        echo "System flake update available: $CURRENT_VERSION -> $LATEST_VERSION"
        ${pkgs.libnotify}/bin/notify-send -u normal "Claude Code Update" "Version $LATEST_VERSION available. Rebuild system to apply." || true
      else
        echo "System flake is already up-to-date"
      fi
    fi
  '';
in
{
  # Systemd service to update flake inputs
  systemd.services.update-claude-code = {
    description = "Update claude-code (flake or user profile)";
    path = [ pkgs.nix pkgs.git pkgs.curl pkgs.jq ];
    script = ''
      ${updateScript}
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "dom";
      Environment = [
        "HOME=/home/dom"
        "PATH=/run/current-system/sw/bin:/home/dom/.nix-profile/bin"
      ];
    };
  };

  # Timer to run the update check daily
  systemd.timers.update-claude-code = {
    description = "Check for claude-code updates daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Run daily at 10 AM
      OnCalendar = "10:00";
      # Also run 5 minutes after boot
      OnBootSec = "5min";
      # If missed, run as soon as possible
      Persistent = true;
      # Randomize by up to 30 minutes to avoid thundering herd
      RandomizedDelaySec = "30min";
    };
  };

  # Service to auto-rebuild if updates are found
  systemd.services.auto-rebuild-claude-code = {
    description = "Auto rebuild system if claude-code updates";
    path = [ pkgs.nix pkgs.git pkgs.nixos-rebuild pkgs.curl pkgs.jq ];
    after = [ "update-claude-code.service" ];
    script = ''
      cd /home/dom/Code/nixos

      # Check if there are changes to flake.lock
      if ! git diff --quiet flake.lock; then
        echo "Updates found for claude-code, rebuilding system..."
        
        # Get version info
        OLD_VERSION=$(claude --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown")
        NEW_VERSION=$(nix run github:sadjow/claude-code-nix -- --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown")

        # Create a backup tag before rebuilding
        git add flake.lock
        git commit -m "Auto-update: claude-code $OLD_VERSION -> $NEW_VERSION" || true

        # Test the configuration first
        if nixos-rebuild dry-build --flake /home/dom/Code/nixos; then
          # Rebuild the system
          nixos-rebuild switch --flake /home/dom/Code/nixos
          
          # Verify the update
          FINAL_VERSION=$(claude --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "unknown")
          
          # Notify user
          ${pkgs.libnotify}/bin/notify-send -u normal "Claude Code Updated" "Successfully updated from v$OLD_VERSION to v$FINAL_VERSION" || true
          echo "Successfully updated Claude Code from $OLD_VERSION to $FINAL_VERSION"
        else
          echo "ERROR: Dry build failed, skipping rebuild"
          ${pkgs.libnotify}/bin/notify-send -u critical "Claude Code Update Failed" "Configuration test failed. Manual intervention required." || true
        fi
      else
        echo "No flake.lock changes detected, skipping rebuild"
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Timer for auto-rebuild - Enabled for automatic updates
  systemd.timers.auto-rebuild-claude-code = {
    description = "Auto rebuild if updates available";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Run 15 minutes after the update check (10:15 AM)
      OnCalendar = "10:15";
      # Also check 10 minutes after boot
      OnBootSec = "10min";
      Persistent = true;
    };
  };
  
  # Manual update command aliases and helper scripts
  environment.shellAliases = {
    update-claude = "systemctl --user start update-claude-code.service 2>/dev/null || sudo systemctl start update-claude-code.service";
    claude-version = "claude --version 2>/dev/null || echo 'Claude Code not installed'";
    claude-check = "nix run github:sadjow/claude-code-nix -- --version";
  };
  
  # Create a user-level service for profile updates
  systemd.user.services.update-claude-code-user = {
    description = "Update Claude Code in user profile";
    path = [ pkgs.nix pkgs.git pkgs.libnotify ];
    script = ''
      ${updateScript}
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
  
  systemd.user.timers.update-claude-code-user = {
    description = "Check for Claude Code updates in user profile";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      OnBootSec = "5min";
      Persistent = true;
    };
  };
}
