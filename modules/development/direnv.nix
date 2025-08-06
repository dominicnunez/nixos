# modules/development/direnv.nix - Automatic environment management
{ pkgs, ... }:

{
  # Enable direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Better nix-shell caching
  };
  
  # Install direnv package
  environment.systemPackages = with pkgs; [
    direnv
    nix-direnv
  ];
  
  # Note: Shell integration for direnv has been moved to Home Manager
  # See modules/home-manager/home.nix
}