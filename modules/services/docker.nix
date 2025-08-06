# modules/services/docker.nix - Docker configuration (simplified)
{ pkgs, config, ... }:

{
  # Docker configuration
  virtualisation.docker = {
    enable = true;
    
    # Enable BuildKit by default for better builds
    daemon.settings = {
      features = {
        buildkit = true;
      };
    };
    
    # Auto-prune old images weekly
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" "--volumes" ];
    };
  };
  
  # Container tools
  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker       # Terminal UI for docker
    dive             # Docker image explorer
  ];
  
  # Add your user to docker group (replace 'aural' with your username)
  users.users.aural = {
    extraGroups = [ "docker" ];
  };
}