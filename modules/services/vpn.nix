# modules/services/vpn.nix - VPN client configuration
{ pkgs, ... }:

{
  # VPN client packages
  environment.systemPackages = with pkgs; [
    # VPN Clients
    openvpn                  # OpenVPN client
    wireguard-tools          # WireGuard tools
    networkmanager-openvpn   # NetworkManager OpenVPN plugin
    networkmanager-l2tp      # L2TP/IPSec support
    
    # GUI VPN Clients
    protonvpn-gui            # ProtonVPN GUI client
    # mullvad-vpn             # Mullvad VPN client (disabled: requires insecure libsoup)
    
    # VPN related tools
    openconnect              # Cisco AnyConnect compatible
    networkmanager-openconnect  # NetworkManager integration
    strongswan               # IPSec VPN
    
    # Additional tools
    dig                      # DNS lookup
    traceroute              # Network path tracking
    nettools                # Network utilities
  ];

  # NetworkManager configuration for VPN
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
      networkmanager-openconnect
      networkmanager-l2tp
    ];
  };

  # WireGuard kernel module
  boot.kernelModules = [ "wireguard" ];

  # Example WireGuard interface configuration (uncomment to use)
  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     address = [ "10.0.0.2/24" ];
  #     dns = [ "1.1.1.1" ];
  #     privateKeyFile = "/home/developer/.wireguard/private.key";
  #     
  #     peers = [
  #       {
  #         publicKey = "SERVER_PUBLIC_KEY_HERE";
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "vpn.example.com:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  # OpenVPN client configuration example (uncomment to use)
  # services.openvpn.servers = {
  #   myVPN = {
  #     config = ''
  #       client
  #       dev tun
  #       proto udp
  #       remote vpn.example.com 1194
  #       resolv-retry infinite
  #       nobind
  #       persist-key
  #       persist-tun
  #       ca /home/developer/.openvpn/ca.crt
  #       cert /home/developer/.openvpn/client.crt
  #       key /home/developer/.openvpn/client.key
  #       verb 3
  #     '';
  #     autoStart = false;
  #   };
  # };

  # Firewall rules for VPN
  networking.firewall = {
    # Allow VPN traffic
    allowedUDPPorts = [ 
      51820  # WireGuard
      1194   # OpenVPN
    ];
    
    # Allow VPN interfaces
    trustedInterfaces = [ "wg0" "tun0" ];
  };
}