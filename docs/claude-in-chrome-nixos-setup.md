# Claude in Chrome Setup for NixOS

After installing Claude Code and the Claude in Chrome extension, NixOS users need two fixes for browser automation to work.

## Prerequisites

- Claude Code installed (via nix, home-manager, etc.)
- "Claude in Chrome" browser extension installed from Chrome Web Store
- Run `claude` once to generate the native host files

## Fix 1: /bin/bash Symlink

Claude Code's native host script uses `#!/bin/bash`, which doesn't exist on NixOS.

Add to your `configuration.nix`:

```nix
system.activationScripts.binBash = ''
  mkdir -p /bin
  ln -sf ${pkgs.bash}/bin/bash /bin/bash
'';
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake /path/to/your/flake#hostname
```

## Fix 2: Node PATH (if using fnm/nvm/asdf)

If you use a node version manager (fnm, nvm, asdf), its dynamically-linked node may be found before nix's node. NixOS can't run dynamically-linked executables, causing the MCP server to fail.

### Option A: User wrapper script (recommended)

Create `~/.local/bin/claude`:

```bash
#!/usr/bin/env bash
# Wrapper that ensures nix's node is found before fnm/nvm node

NIX_NODE_DIR="$(dirname "$(readlink -f /etc/profiles/per-user/$USER/bin/node)")"
export PATH="$NIX_NODE_DIR:$PATH"

exec /etc/profiles/per-user/$USER/bin/claude "$@"
```

Make it executable:
```bash
chmod +x ~/.local/bin/claude
```

Ensure `~/.local/bin` is first in your PATH. In your shell config (`.bashrc`, `.zshrc`, or via home-manager):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Option B: Remove fnm/nvm from PATH

If you don't need fnm/nvm, simply remove it from your shell config and rely on nix's node.

## Verification

1. **Start a new terminal** (to pick up PATH changes)

2. **Restart Chrome completely**:
   ```bash
   pkill -f google-chrome && google-chrome-stable &
   ```

3. **Start Claude Code** and run `/chrome`:
   ```
   claude
   /chrome
   ```

   You should see **Status: Enabled**

4. **Check MCP server** with `/mcp`:
   - "Claude-in-chrome MCP Server" should show **Status: running**

## Troubleshooting

If `/chrome` doesn't show Enabled:

```bash
# Check /bin/bash exists
ls -la /bin/bash

# Test native host runs without error
~/.claude/chrome/chrome-native-host --version

# Check for native host process after opening Chrome
ps aux | grep chrome-native-host
```

If MCP server shows failed:

```bash
# Check which node is being used
which node

# Should point to nix store, not ~/.fnm or ~/.nvm
# If not, the wrapper script isn't being used
```

## Why This Is Needed

1. **Shebang issue**: Claude Code generates scripts with `#!/bin/bash`. NixOS doesn't have `/bin/bash` - bash is in the Nix store.

2. **Dynamic linking**: Node version managers install dynamically-linked binaries. NixOS uses a different libc path, so these binaries fail with "not found" errors even when they exist.
