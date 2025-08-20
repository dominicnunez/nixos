# modules/home-manager/aliases.nix - Custom shell aliases configuration
{ config, pkgs, lib, ... }:

{
  # Shell aliases available in all shells
  shellAliases = {
    # ===== Navigation =====
    ll = "eza -l";
    la = "eza -la";
    lt = "eza --tree";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    
    # ===== Git Shortcuts =====
    g = "git";
    gs = "git status";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    ga = "git add";
    gco = "git checkout";
    gb = "git branch";
    glog = "git log --oneline --graph --decorate";
    
    # ===== Modern CLI Replacements =====
    cat = "bat";                # Better cat with syntax highlighting
    find = "fd";                # Faster, user-friendly find
    grep = "rg";                # Ripgrep - faster grep
    ps = "procs";               # Modern ps with tree view
    top = "btop";               # Beautiful resource monitor
    df = "duf";                 # Better df with colors
    du = "dust";                # Intuitive du with tree view
    ping = "gping";             # Ping with graph
    
    # ===== Productivity Tools =====
    cd = "z";                   # Zoxide smart directory jumping
    cdi = "zi";                 # Interactive directory selection
    lg = "lazygit";             # Terminal UI for git
    
    # ===== AI Tools =====
    c = "claude";               # Claude AI CLI
    gm = "gemini";              # Gemini AI CLI
    cctkn = "uv run /home/aural/.claude/token_usage_report.py";  # Claude token usage
    
    # ===== System Shortcuts =====
    cls = "clear";
    mkdir = "mkdir -pv";        # Create parent directories, verbose
    cp = "cp -iv";              # Interactive, verbose copy
    mv = "mv -iv";              # Interactive, verbose move
    rm = "rm -iv";              # Interactive, verbose remove (safer)
    
    # ===== Node.js =====
    nvm = "fnm";                # Fast Node Manager (nvm compatibility)
    
    # ===== NixOS Specific =====
    rebuild = "sudo nixos-rebuild switch --flake /home/aural/Code/nixos";
    rebuild-test = "sudo nixos-rebuild test --flake /home/aural/Code/nixos";
    rebuild-boot = "sudo nixos-rebuild boot --flake /home/aural/Code/nixos";
    
    nix-clean = "sudo nix-collect-garbage -d";
    nix-clean-old = "sudo nix-collect-garbage --delete-older-than 7d";
    nix-optimize = "sudo nix-store --optimise";
    nix-search = "nix search nixpkgs";
    nix-shell-pure = "nix-shell --pure";
    
    # ===== Application Fixes =====
    # Notion alternatives (if Chromium wrapper fails)
    notion-desktop = "notion-app-enhanced --use-gl=desktop";     # Best performance
    notion-angle = "notion-app-enhanced --use-gl=angle";         # Alternative GL
    notion-software = "notion-app-enhanced --disable-gpu";       # Software rendering
    notion-debug = "notion-app-enhanced --enable-logging --v=1"; # Debug mode
    
    # ===== Screen Recording =====
    record-gif = "kooha";  # GIF recorder with native Wayland support
    record-screen = "obs";  # Professional screen recording
    gpu-record = "gpu-screen-recorder-gtk";  # GPU-accelerated recording
    
    # ===== Quick Edits =====
    nixconf = "cd /home/aural/Code/nixos && $EDITOR";
    aliases = "$EDITOR /home/aural/Code/nixos/modules/home-manager/aliases.nix";
    
    # ===== System Information =====
    sysinfo = "neofetch";
    ports = "sudo lsof -i -P -n | grep LISTEN";
    myip = "curl ifconfig.me";
    localip = "ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}'";
    
    # ===== Process Management =====
    psg = "ps aux | grep -v grep | grep -i";
    killport = "sudo lsof -t -i:$1 | xargs sudo kill -9";
    
    # ===== Archives =====
    untar = "tar -xvf";
    mktar = "tar -czvf";
    
    # ===== Safety Nets =====
    wget = "wget -c";           # Continue partial downloads
    ln = "ln -i";               # Prompt before overwriting
    chown = "chown --preserve-root";
    chmod = "chmod --preserve-root";
    chgrp = "chgrp --preserve-root";
  };
}