# NixOS Configuration Migration to Home Manager

## Overview
This document tracks the incremental migration of NixOS system configurations to Home Manager for better user-specific management. All components use NixOS 25.05.

## Migration Principles
- ✅ Always use NixOS 25.05 for all components
- ✅ Test each change incrementally
- ✅ Copy from git working directory to /etc/nixos before rebuilding
- ✅ Use `sudo nixos-rebuild test` first, then `switch` if successful
- ✅ Commit after each successful phase

## Phase 1: Core User Environment
### 1.1 Terminal Configuration
- [ ] Create `modules/home-manager/terminal.nix`
- [ ] Migrate bash configuration from system
- [ ] Migrate fish configuration if present
- [ ] Migrate zsh configuration if present
- [ ] Test with `nixos-rebuild test`

### 1.2 Shell Aliases and Environment
- [ ] Move aliases from `modules/development/productivity.nix`
- [ ] Migrate environment variables
- [ ] Configure shell integrations (zoxide, atuin, fzf)
- [ ] Test all aliases work correctly

### 1.3 SSH Client Configuration
- [ ] Create SSH client config in Home Manager
- [ ] Migrate SSH keys and known_hosts
- [ ] Configure SSH agent
- [ ] Keep SSH server in system config

### 1.4 Tmux User Configuration
- [ ] Move tmux config to Home Manager
- [ ] Migrate keybindings and preferences
- [ ] Test persistent sessions
- [ ] Verify all plugins work

## Phase 2: Development Tools
### 2.1 Development Module Structure
- [ ] Create `modules/home-manager/development.nix`
- [ ] Structure for language-specific tools
- [ ] Git configuration (enhance existing)
- [ ] Test development workflow

### 2.2 Productivity Tools
- [ ] Migrate lazygit configuration
- [ ] Migrate gitui settings
- [ ] Configure delta for git diffs
- [ ] Move git-extras and hub configs

### 2.3 Language-Specific Tools
- [ ] Python development tools
- [ ] JavaScript/Node.js tools
- [ ] Rust toolchain
- [ ] Go development environment
- [ ] Test each language setup

## Phase 3: Desktop Applications
### 3.1 Application Management
- [ ] Create `modules/home-manager/applications.nix`
- [ ] Categorize apps (system vs user)
- [ ] Move user-specific apps to Home Manager
- [ ] Test application launches

### 3.2 Browser Configuration
- [ ] Create `modules/home-manager/browsers.nix`
- [ ] Firefox profiles and preferences
- [ ] Chrome/Chromium settings
- [ ] Brave configuration
- [ ] Test browser profiles

### 3.3 Media and Productivity Apps
- [ ] Spotify configuration
- [ ] VLC settings
- [ ] Obsidian vault settings
- [ ] LibreOffice preferences
- [ ] Discord settings
- [ ] Thunderbird mail config

## Phase 4: Desktop Environments
### 4.1 DE Module Structure
- [ ] Create `modules/home-manager/desktop-environments/` directory
- [ ] Plan modular DE configuration
- [ ] Separate system vs user settings
- [ ] Document switching mechanism

### 4.2 KDE Plasma Configuration
- [ ] Create `modules/home-manager/desktop-environments/plasma.nix`
- [ ] Migrate KDE settings (kdeglobals)
- [ ] Configure Plasma widgets
- [ ] Theme and appearance settings
- [ ] Keyboard shortcuts
- [ ] Test Plasma session

### 4.3 XFCE Configuration
- [ ] Create `modules/home-manager/desktop-environments/xfce.nix`
- [ ] XFCE panel configuration
- [ ] Window manager settings
- [ ] Theme configuration
- [ ] Test XFCE session

### 4.4 Window Managers
- [ ] Create i3 configuration module
- [ ] Create Hyprland configuration
- [ ] Create Sway configuration
- [ ] Configure polybar/waybar
- [ ] Test each WM

## Phase 5: Gaming Configuration
### 5.1 Gaming Module
- [ ] Create `modules/home-manager/gaming.nix`
- [ ] Steam user settings
- [ ] MangoHud configuration
- [ ] GameMode settings
- [ ] Test game launches

### 5.2 Game Launchers
- [ ] Lutris configuration
- [ ] Heroic launcher settings
- [ ] Bottles preferences
- [ ] Controller mappings
- [ ] Test each launcher

## Phase 6: System Integration
### 6.1 XDG Configuration
- [ ] Configure mime associations
- [ ] Set default applications
- [ ] Desktop file associations
- [ ] Test file opens

### 6.2 User Services
- [ ] Identify user systemd services
- [ ] Migrate to Home Manager
- [ ] Configure autostart apps
- [ ] Test service management

### 6.3 Final Optimization
- [ ] Review all migrations
- [ ] Remove duplicated configs
- [ ] Performance testing
- [ ] Documentation update
- [ ] Final commit

## Testing Checklist
For each phase:
- [ ] Changes work in local git directory
- [ ] Files copied to /etc/nixos
- [ ] `sudo nixos-rebuild test` succeeds
- [ ] Functionality verified
- [ ] `sudo nixos-rebuild switch` applied
- [ ] Changes committed to git

## Commands Reference
```bash
# Test configuration
sudo nixos-rebuild test

# Apply configuration
sudo nixos-rebuild switch

# Copy to system
sudo cp -r /home/aural/Documents/nixos/* /etc/nixos/

# Check current version
nixos-version

# Commit changes
git add .
git commit -m "Phase X.Y: Description"
```

## Notes
- System-wide configurations remain in `/etc/nixos`
- User-specific configurations move to Home Manager
- Desktop environments have both system and user components
- Always maintain backwards compatibility during migration