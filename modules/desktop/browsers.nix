# modules/desktop/browsers.nix - System-level browser configuration
# Note: Browser packages and user configs are in home-manager/browsers.nix
{ pkgs, ... }:

{
  # Enable Firefox at system level (required for some policies)
  programs.firefox.enable = true;

  # Set default browser associations (system-level MIME types)
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}