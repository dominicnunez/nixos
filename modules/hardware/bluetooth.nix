# modules/hardware/bluetooth.nix - Bluetooth configuration
{ config, pkgs, lib, ... }:

{
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    
    # Additional settings
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;  # Enable experimental features
        FastConnectable = true;
        
        # Better audio quality for A2DP
        MultiProfile = "multiple";
      };
      
      Policy = {
        AutoEnable = true;
      };
    };
  };
  
  # Bluetooth manager and audio
  services.blueman.enable = true;
  
  # PulseAudio/PipeWire Bluetooth support (you're using PipeWire)
  # This is likely already enabled in your audio config, but let's ensure it
  hardware.pulseaudio.enable = false;  # We use PipeWire
  
  # Packages for Bluetooth management
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    bluez-alsa
  ];
  
  # Enable the Bluetooth service
  systemd.services.bluetooth.enable = true;
  
  # For KDE Plasma (automatic Bluetooth integration)
  # KDE Plasma already includes bluedevil for Bluetooth management
  # No additional configuration needed for KDE
}