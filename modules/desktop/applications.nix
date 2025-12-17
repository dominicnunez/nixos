# modules/desktop/applications.nix - System-level desktop applications
# Note: User applications have been moved to home-manager configuration
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # KDE System Integration
    kdePackages.kdeconnect-kde
    kdePackages.ark  # Archive manager for KDE (Qt6 version)

    # System Audio Framework (JACK)
    qjackctl         # JACK control GUI
    jack2            # JACK audio connection kit
    carla            # Audio plugin host

    # System Text-to-Speech
    espeak           # Compact text-to-speech synthesizer
  ];

  # Required for proprietary packages
  nixpkgs.config.allowUnfree = true;
}
