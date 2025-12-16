# modules/services/ssh.nix - SSH server configuration
{ pkgs, ... }:

{
  # OpenSSH server configuration
  services.openssh = {
    enable = true;
    ports = [ 2222 ];  # Non-standard port for security
    
    settings = {
      # Authentication settings
      PasswordAuthentication = false;  # Require key-based auth
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      
      # Modern cryptography only
      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
      ];
      
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];
      
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
      
      # Connection settings
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      MaxAuthTries = 3;
      MaxSessions = 10;
      
      # Security settings
      StrictModes = true;
      IgnoreRhosts = true;
      HostbasedAuthentication = false;
      
      # X11 forwarding (useful for GUI apps)
      X11Forwarding = true;
      
      # Allow port forwarding (useful for development)
      AllowTcpForwarding = true;
      GatewayPorts = "no";
      
      # SFTP configuration
      Subsystem = "sftp /run/current-system/sw/libexec/sftp-server";
    };
    
    # Additional configuration
    extraConfig = ''
      # Rate limiting
      MaxStartups 10:30:100
      
      # Banner message
      Banner /etc/ssh/banner
      
      # Allow specific users only
      AllowUsers dom
      
      # Logging
      LogLevel VERBOSE
    '';
  };
  
  # Create SSH banner
  environment.etc."ssh/banner" = {
    text = ''
      ############################################################
      #                                                          #
      #  Authorized access only. All activity is monitored.     #
      #  Disconnect immediately if you are not authorized.      #
      #                                                          #
      ############################################################
    '';
  };
  
  # SSH keys for dom user (replace with your actual public key)
  users.users.dom.openssh.authorizedKeys.keys = [
    # Add your SSH public key here
    # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@hostname"
  ];
  
  # Tmux for persistent sessions
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    historyLimit = 50000;
    
    extraConfig = ''
      # Enable mouse support
      set -g mouse on
      
      # Better pane navigation
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      
      # Better window navigation
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      
      # Split panes with | and -
      bind | split-window -h
      bind - split-window -v
      
      # Reload config
      bind r source-file /etc/tmux.conf \; display "Config reloaded!"
      
      # Status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-left '#[fg=green]#H #[fg=yellow]| '
      set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M'
      
      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on
    '';
  };
  
  # SSH agent
  programs.ssh.startAgent = true;
  
  # Mosh for mobile connections
  programs.mosh.enable = true;
  
  # Additional SSH tools
  environment.systemPackages = with pkgs; [
    openssh
    mosh
    sshfs
    ssh-audit
    ssh-copy-id
    autossh
    tmux
    tmuxinator
    screen
  ];
}