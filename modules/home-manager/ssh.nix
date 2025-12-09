# modules/home-manager/ssh.nix - SSH client configuration for user
{ config, pkgs, lib, ... }:

{
  # SSH client configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # Disable default SSH config warnings

    # Host-specific configurations
    matchBlocks = {
      # Global defaults for all hosts
      "*" = {
        forwardAgent = false;
        forwardX11 = false;
        hashKnownHosts = true;
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        extraOptions = {
          PasswordAuthentication = "no";
          ConnectTimeout = "10";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/sockets/%r@%h-%p";
          ControlPersist = "600";
          KexAlgorithms = "curve25519-sha256@libssh.org,diffie-hellman-group16-sha512";
          Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com";
          MACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com";
          HostKeyAlgorithms = "ssh-ed25519,rsa-sha2-512,rsa-sha2-256";
        };
      };
      # Example GitHub configuration
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github_ed25519";
        identitiesOnly = true;
        extraOptions = {
          PreferredAuthentications = "publickey";
        };
      };
      
      # Example GitLab configuration
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/gitlab_ed25519";
        identitiesOnly = true;
        extraOptions = {
          PreferredAuthentications = "publickey";
        };
      };
      
      # Example home server configuration
      # Uncomment and modify as needed
      # "homeserver" = {
      #   hostname = "192.168.1.100";
      #   user = "aural";
      #   port = 2222;
      #   identityFile = "~/.ssh/homeserver_ed25519";
      #   forwardX11 = true;
      #   forwardX11Trusted = true;
      # };
      
      # Example work server with jump host
      # "work-server" = {
      #   hostname = "internal.work.com";
      #   user = "username";
      #   proxyJump = "bastion.work.com";
      #   identityFile = "~/.ssh/work_ed25519";
      # };
    };
  };
  
  # SSH agent configuration (already in system, but user config here)
  services.ssh-agent = {
    enable = true;
  };
  
  # Create SSH sockets directory for connection multiplexing
  home.file.".ssh/sockets/.keep".text = "";
  
  # SSH configuration file permissions
  home.file.".ssh/config" = {
    enable = false;  # Let programs.ssh manage this
  };
  
  # SSH key generation script
  home.file.".local/bin/ssh-keygen-ed25519" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Helper script to generate Ed25519 SSH keys
      
      if [ $# -eq 0 ]; then
        echo "Usage: ssh-keygen-ed25519 <keyname> [comment]"
        echo "Example: ssh-keygen-ed25519 github 'aural@github'"
        exit 1
      fi
      
      KEYNAME="$1"
      COMMENT="''${2:-$USER@$(hostname)}"
      
      ssh-keygen -t ed25519 -f ~/.ssh/''${KEYNAME}_ed25519 -C "$COMMENT"
      
      echo "Key generated at ~/.ssh/''${KEYNAME}_ed25519"
      echo "Public key:"
      cat ~/.ssh/''${KEYNAME}_ed25519.pub
    '';
  };
  
  # SSH utilities
  home.packages = with pkgs; [
    # SSH tools
    ssh-copy-id     # Copy SSH keys to servers
    ssh-audit       # SSH server auditing
    sshpass         # Non-interactive SSH password provider (use carefully)
    autossh         # Automatically restart SSH sessions
    
    # SSH filesystem
    sshfs           # Mount remote filesystems over SSH
    
    # Terminal utilities for SSH sessions
    mosh            # Mobile shell (better for unstable connections)
  ];
  
  # Known hosts file
  home.file.".ssh/known_hosts" = {
    text = ''
      # GitHub
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
      github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
      github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
      
      # GitLab
      gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
      gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
      gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi35aw3OFtR/7ibPt3Z3DfnVxn4sCpFqt8jgdNTjHOLHPZg7dxBYwGXapkvu8KDD7VzjxmhzRkVH/Az7tLWW7UJmVdvLH6K3IG8hNQcAZzYQk3dBRkZvgi9k0JoS+BrXlOPbSfMRGVZu/mJdgSc4XXrOJWaHHhKVDHDU+qU4RsC33kfQcLqw1XMoYqDxTxMYl5bTUtYbPcixpB5h6fRX4mb93TB4dQPE5LmJBS7nfKDCQ5F
    '';
  };
  
  # SSH aliases for common operations
  programs.bash.shellAliases = {
    # SSH key management
    ssh-list = "ssh-add -l";
    ssh-add-all = "ssh-add ~/.ssh/*_ed25519 2>/dev/null";
    ssh-forget = "ssh-add -D";
    
    # Quick SSH connections (customize as needed)
    # sshh = "ssh homeserver";
    # sshw = "ssh work-server";
    
    # SSH tunneling helpers
    ssh-tunnel = "echo 'Usage: ssh -L local_port:destination:remote_port user@server'";
    ssh-reverse = "echo 'Usage: ssh -R remote_port:destination:local_port user@server'";
    ssh-socks = "echo 'Usage: ssh -D 8080 user@server (then use localhost:8080 as SOCKS proxy)'";
  };
}