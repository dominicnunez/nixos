# NixOS Configuration Project Notes

## NixOS-Specific Fixes

### Claude in Chrome Integration
**Status**: Resolved

See `docs/claude-in-chrome-nixos-setup.md` for setup instructions on a fresh install.

Two fixes were required:
1. `/bin/bash` symlink - Claude Code's native host uses `#!/bin/bash` shebang
2. Node PATH wrapper - Ensures nix's node is used instead of fnm/nvm's dynamically-linked node

## Project Structure

- `configuration.nix` - Main NixOS configuration
- `flake.nix` - Flake definition with claude-code overlay
- `modules/` - Modular configuration files
- `docs/` - Documentation for fixes and workarounds

## NixOS-Specific Workarounds

### /bin/bash Compatibility
Many tools expect `/bin/bash` to exist. We create a symlink via activation script:
```nix
system.activationScripts.binBash = ''
  mkdir -p /bin
  ln -sf ${pkgs.bash}/bin/bash /bin/bash
'';
```

## Commands

- Rebuild system: `sudo nixos-rebuild switch --flake /home/dom/Code/nixos#nixos`
- Update flake: `nix flake update`
- Home manager switch: `home-manager switch --flake /home/dom/Code/nixos`
