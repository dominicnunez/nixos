# NixOS Configuration

Personal NixOS configuration using flakes for system reproducibility and declarative package management.

## System Information

- **Hostname**: sinistercat
- **NixOS Version**: 25.11
- **Architecture**: x86_64-linux

## Structure

```
.
├── flake.nix                    # Flake configuration with inputs
├── flake.lock                   # Locked versions of dependencies
├── configuration.nix            # Main system configuration
├── hardware-configuration.nix   # Hardware-specific settings
└── modules/                     # Modular configuration
    ├── development/             # Development tools & languages
    ├── desktop/                 # Desktop environments & applications
    ├── hardware/                # Hardware configuration (GPU, Bluetooth)
    ├── services/                # System services (Docker, SSH, VPN)
    ├── system/                  # System utilities
    └── security/                # Security hardening
```

## Quick Start

### Apply Configuration Changes

After editing configuration files:

```bash
sudo nixos-rebuild switch --flake .
```

### Test Configuration (without switching)

```bash
sudo nixos-rebuild test --flake .
```

## Updating Packages

### Update Claude Code Only

When a new version of Claude Code is released:

```bash
nix flake lock --update-input claude-code
sudo nixos-rebuild switch --flake .
```

### Update All Flake Inputs

To update nixpkgs, home-manager, and claude-code:

```bash
nix flake update
sudo nixos-rebuild switch --flake .
```

### Update Specific Input

To update only one input (replace `INPUT_NAME`):

```bash
nix flake lock --update-input INPUT_NAME
sudo nixos-rebuild switch --flake .
```

## Flake Inputs

- **nixpkgs**: NixOS package repository (25.11 stable)
- **home-manager**: User environment and dotfiles manager
- **claude-code**: Claude Code AI assistant

## Features

- Modular configuration for easy maintenance
- Desktop environment switcher (GNOME/KDE/Hyprland support)
- AMD GPU hardware acceleration
- Development tools and language support
- Docker and containerization
- VPN and security hardening
- Gaming support (Steam with Vulkan fixes)
- Automatic flake updates (if enabled)

## Useful Commands

### Shell Aliases (available in your terminal)

This configuration includes helpful aliases for common tasks:

```bash
# NixOS Management
rebuild              # Rebuild and switch to new configuration
rebuild-test         # Test configuration without switching
rebuild-boot         # Apply on next boot only
nixconf              # Quick edit configuration files
aliases              # Edit the aliases file

# Nix Package Management
nix-clean            # Remove all old generations
nix-clean-old        # Remove generations older than 7 days
nix-optimize         # Optimize nix store (deduplicate)
nix-search           # Search for packages

# Git Shortcuts
gs                   # git status
gc                   # git commit
gp                   # git push
gl                   # git pull
glog                 # Pretty git log with graph

# Modern CLI Tools
cat                  # bat (syntax highlighting)
ls                   # eza (better ls)
find                 # fd (faster find)
grep                 # rg (ripgrep)
top                  # btop (beautiful top)
```

### Direct Commands

```bash
# Check current configuration generation
nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Garbage collect old generations
sudo nix-collect-garbage -d

# Check flake inputs status
nix flake metadata

# Update and show what changed
nix flake update && nix flake show
```

## Troubleshooting

### Rebuild fails
- Check syntax: `nix flake check`
- View detailed errors: Add `--show-trace` flag

### Package version issues
- Check locked version: `nix flake metadata`
- Force update input: `nix flake lock --update-input <input>`

### Git dirty tree warnings
- Normal when you have uncommitted changes
- Commit changes to remove warning (optional)
