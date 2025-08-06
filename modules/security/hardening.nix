# modules/security/hardening.nix - Security hardening configuration
{ config, pkgs, lib, ... }:

{
  # Import hardened profile (optional - very strict)
  # imports = [ <nixpkgs/nixos/modules/profiles/hardened.nix> ];
  
  # Firewall configuration
  networking.firewall = {
    enable = true;
    
    # Default policies
    allowPing = false;
    logRefusedConnections = true;
    logRefusedPackets = true;
    logReversePathDrops = true;
    
    # Allowed ports
    allowedTCPPorts = [ 
      2222   # SSH
      # 80   # HTTP (uncomment if needed)
      # 443  # HTTPS (uncomment if needed)
    ];
    
    allowedUDPPorts = [ 
      # 51820  # WireGuard (uncomment if needed)
    ];
    
    # Per-interface rules (example for development ports on local network)
    interfaces = {
      "lo" = {
        allowedTCPPorts = [ 3000 5432 6379 8080 8000 ];  # Local development ports
      };
    };
    
    # Extra iptables commands
    extraCommands = ''
      # Drop invalid packets
      iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
      
      # Rate limiting for SSH
      iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -m recent --set
      iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 4 -j DROP
      
      # SYN flood protection
      iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
    '';
    
    extraStopCommands = ''
      iptables -D INPUT -m conntrack --ctstate INVALID -j DROP 2>/dev/null || true
    '';
  };
  
  # Fail2ban for brute force protection
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";
    bantime-increment.enable = true;
    
    jails = {
      ssh = {
        enabled = true;
        port = 2222;
        filter = "sshd";
        maxretry = 3;
        findtime = 600;
        bantime = 3600;
      };
    };
  };
  
  # Kernel hardening
  boot.kernel.sysctl = {
    # Network security
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
    
    # Kernel hardening
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.ftrace_enabled" = false;
    
    # Process security
    "kernel.pid_max" = 65536;
    "kernel.panic" = 10;
    "kernel.panic_on_oops" = 1;
    
    # File system protection
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_regular" = 2;
    "fs.protected_fifos" = 2;
  };
  
  # Security packages and tools
  environment.systemPackages = with pkgs; [
    # Security audit tools
    lynis          # Security auditing
    chkrootkit     # Rootkit detection
    clamav         # Antivirus
    aide           # File integrity
    
    # Network security
    nmap
    wireshark
    tcpdump
    iptables
    nftables
    
    # Cryptography
    gnupg
    openssl
    age            # Modern encryption
    sops           # Secret management
    
    # Password management
    pass
    bitwarden-cli
    keepassxc
    
    # System monitoring
    auditd
    sysstat
    iotop
    nethogs
  ];
  
  # Audit daemon
  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
    "-w /etc/passwd -p wa"
    "-w /etc/shadow -p wa"
    "-w /etc/sudoers -p wa"
  ];
  
  # AppArmor (application sandboxing)
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };
  
  # Automatic security updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;  # Manual reboot for servers
    dates = "04:00";
    flake = "/etc/nixos#dev-server";
  };
  
  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    execWheelOnly = true;
    
    extraRules = [
      {
        users = [ "developer" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/systemctl restart";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    
    extraConfig = ''
      # Require password for sudo after 5 minutes
      Defaults timestamp_timeout=5
      
      # Insults for wrong passwords (optional fun)
      Defaults insults
      
      # Log sudo commands
      Defaults logfile="/var/log/sudo.log"
    '';
  };
  
  # User security
  users = {
    mutableUsers = false;  # Users defined only in configuration
    
    users.root = {
      hashedPassword = "!";  # Disable root password
    };
  };
  
  # Login restrictions
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "core";
      value = "0";
    }
  ];
}