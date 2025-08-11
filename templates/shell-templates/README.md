# Shell.nix Templates

This directory contains templates for project-specific development environments using Nix shells.

## Available Templates

- **nodejs.nix** - Node.js/JavaScript/TypeScript projects
- **golang.nix** - Go projects  
- **python.nix** - Python projects
- **fullstack.nix** - Full-stack projects (frontend + backend + database)

## Usage

### Manual Usage

1. Copy the appropriate template to your project root as `shell.nix`:
   ```bash
   cp ~/Code/nixos/templates/shell-templates/nodejs.nix ~/my-project/shell.nix
   ```

2. Enter the development environment:
   ```bash
   cd ~/my-project
   nix-shell
   ```

### Automatic with direnv (Recommended)

1. Copy the template to your project as `shell.nix`

2. Create a `.envrc` file in your project root:
   ```bash
   echo "use nix" > .envrc
   ```

3. Allow direnv to load the environment:
   ```bash
   direnv allow
   ```

Now the environment will automatically load when you enter the directory!

## Customization

Each template includes:
- Common tools for that language/stack
- Commented sections for additional tools
- Environment variables
- Automatic dependency installation in shellHook

Feel free to uncomment or add packages as needed for your specific project.

## System-wide vs Project-specific

Your NixOS system already provides many common tools system-wide:
- Git, neovim, tmux
- ripgrep, fd, fzf, bat
- lazygit, zoxide, atuin
- PostgreSQL, Redis (as services)

Use shell.nix for:
- Specific language versions
- Project-specific tools
- Build dependencies
- Testing frameworks
- Linters/formatters specific to the project

## Creating Your Own Template

Start with the closest template and modify:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Your packages here
  ];
  
  shellHook = ''
    # Your setup commands here
  '';
  
  # Your environment variables here
}
```