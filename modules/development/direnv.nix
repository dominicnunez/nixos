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
  
  # Shell integration for bash (your default shell)
  programs.bash.interactiveShellInit = ''
    # Initialize direnv
    eval "$(direnv hook bash)"
  '';
}