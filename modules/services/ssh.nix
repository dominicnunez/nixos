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

  # SSH agent
  programs.ssh.startAgent = true;
  
  # Mosh for mobile connections
  programs.mosh.enable = true;
}