# modules/home-manager/default.nix - Home Manager configuration
{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "sha256:026rvynmzmpigax9f8gy9z67lsl6dhzv2p6s8wz4w06v3gjvspm1";
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  # Enable home-manager for the aural user
  home-manager = {
    # Use the system's pkgs
    useGlobalPkgs = true;
    
    # Make home-manager use the system's Nixpkgs config (allow unfree, etc.)
    useUserPackages = true;
    
    # User-specific configuration
    users.aural = import ./home.nix;
    
    # Optional: Keep backups of existing files
    backupFileExtension = "backup";
  };
}