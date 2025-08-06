# modules/home-manager/tmux.nix - Tmux user configuration
{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    
    # Basic settings
    terminal = "screen-256color";
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;  # Start windows at 1
    escapeTime = 0;  # No delay for escape key
    
    # Prefix key (default is Ctrl-b, you can change to Ctrl-a)
    prefix = "C-b";
    
    # Shell
    shell = "${pkgs.bash}/bin/bash";
    
    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible           # Basic tmux settings everyone can agree on
      yank              # Tmux clipboard support
      pain-control      # Better pane management
      sessionist        # Session management
      resurrect         # Restore tmux environment after restart
      continuum         # Continuous saving of tmux environment
      
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "cpu-usage ram-usage time"
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-show-left-icon session
          set -g @dracula-cpu-usage-label "CPU"
          set -g @dracula-ram-usage-label "RAM"
        '';
      }
    ];
    
    # Extra configuration
    extraConfig = ''
      # ==== General Settings ====
      
      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides ",alacritty:Tc"
      
      # Set window notifications
      setw -g monitor-activity on
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      set -g bell-action none
      
      # Renumber windows when one is closed
      set -g renumber-windows on
      
      # Increase repeat time for repeatable commands
      set -g repeat-time 500
      
      # ==== Key Bindings ====
      
      # Reload configuration
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # New window with current path
      bind c new-window -c "#{pane_current_path}"
      
      # Navigate panes with vim-like keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Navigate panes with Alt + arrow keys (no prefix needed)
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      # Navigate windows with Shift + arrow keys
      bind -n S-Left previous-window
      bind -n S-Right next-window
      
      # Navigate windows with Alt + number
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
      
      # Resize panes with vim keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Resize panes with Ctrl + arrow keys
      bind -r C-Left resize-pane -L 5
      bind -r C-Down resize-pane -D 5
      bind -r C-Up resize-pane -U 5
      bind -r C-Right resize-pane -R 5
      
      # ==== Copy Mode (Vi) ====
      
      # Enter copy mode with prefix + [
      # Use vi keys to navigate
      # v to start selection
      # y to copy selection
      # prefix + ] to paste
      
      bind Enter copy-mode
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send-keys -X cancel
      
      # Copy to system clipboard (requires xclip or wl-clipboard)
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      
      # ==== Session Management ====
      
      # Create new session
      bind N new-session
      
      # Find session
      bind f command-prompt -p find-session 'switch-client -t %%'
      
      # Session navigation
      bind -n M-s choose-session
      bind -n M-( switch-client -p
      bind -n M-) switch-client -n
      
      # ==== Window Management ====
      
      # Kill pane/window/session
      bind x kill-pane
      bind X kill-window
      bind Q kill-session
      
      # Swap windows
      bind -n C-S-Left swap-window -t -1\; select-window -t -1
      bind -n C-S-Right swap-window -t +1\; select-window -t +1
      
      # Toggle synchronize panes (send input to all panes)
      bind S setw synchronize-panes
      
      # ==== Status Bar ====
      
      # Status bar position
      set -g status-position bottom
      
      # Update status bar every second
      set -g status-interval 1
      
      # Status bar colors (if not using dracula theme)
      # set -g status-style bg=black,fg=white
      # set -g window-status-current-style bg=blue,fg=white,bold
      # set -g pane-border-style fg=white
      # set -g pane-active-border-style fg=blue
      
      # ==== Resurrect/Continuum Settings ====
      
      # Restore vim sessions
      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'
      
      # Restore pane contents
      set -g @resurrect-capture-pane-contents 'on'
      
      # Automatic restore
      set -g @continuum-restore 'on'
      
      # Save session every 15 minutes
      set -g @continuum-save-interval '15'
      
      # ==== Custom Functions ====
      
      # Toggle pane zoom with Z
      bind Z resize-pane -Z
      
      # Open new pane with current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      
      # Quick pane cycling
      unbind ^B
      bind ^B select-pane -t :.+
      
      # Display pane numbers for longer
      set -g display-panes-time 2000
      
      # Logging output
      bind P pipe-pane -o "cat >>~/tmux-#W.log" \; display "Toggled logging to ~/tmux-#W.log"
    '';
  };
  
  # Tmuxinator package for session management
  home.packages = with pkgs; [
    tmuxinator
  ];
  
  # Create example tmuxinator projects
  home.file.".config/tmuxinator/dev.yml" = {
    text = ''
      # ~/.config/tmuxinator/dev.yml
      name: dev
      root: ~/projects
      
      windows:
        - editor:
            layout: main-vertical
            panes:
              - nvim
              - # empty pane
        - git:
            panes:
              - lazygit
        - terminal:
            layout: even-horizontal
            panes:
              - # empty pane
              - # empty pane
        - logs:
            panes:
              - tail -f /var/log/syslog
    '';
  };
  
  home.file.".config/tmuxinator/nixos.yml" = {
    text = ''
      # ~/.config/tmuxinator/nixos.yml
      name: nixos
      root: ~/Documents/nixos
      
      windows:
        - config:
            layout: main-vertical
            panes:
              - nvim configuration.nix
              - # terminal for testing
        - rebuild:
            panes:
              - # terminal for rebuilding
        - logs:
            panes:
              - journalctl -f
    '';
  };
  
  # Shell aliases for tmux
  programs.bash.shellAliases = {
    # Tmux shortcuts
    ta = "tmux attach -t";
    tad = "tmux attach -d -t";
    ts = "tmux new-session -s";
    tl = "tmux list-sessions";
    tksv = "tmux kill-server";
    tkss = "tmux kill-session -t";
    
    # Tmuxinator shortcuts
    mux = "tmuxinator";
    muxs = "tmuxinator start";
    muxe = "tmuxinator edit";
    muxl = "tmuxinator list";
    
    # Quick sessions
    tdev = "tmuxinator start dev";
    tnix = "tmuxinator start nixos";
  };
}