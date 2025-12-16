# modules/home-manager/default.nix - Home Manager configuration
{ config, pkgs, ... }:

{
  # Enable home-manager for the dom user
  home-manager = {
    # Use the system's pkgs
    useGlobalPkgs = true;

    # Make home-manager use the system's Nixpkgs config (allow unfree, etc.)
    useUserPackages = true;

    # User-specific configuration
    users.dom = import ./home.nix;
    
    # Optional: Keep backups of existing files
    backupFileExtension = "backup";
  };
}