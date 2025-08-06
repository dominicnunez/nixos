# modules/desktop/browsers.nix - Web browsers configuration
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Primary browsers (Firefox already enabled in main config)
    brave
    google-chrome
    
    # Optional: Chromium as open-source alternative
    chromium
  ];
  
  # Firefox is already configured in main configuration.nix
  # We can enhance it here with additional policies if needed
  programs.firefox = {
    enable = true;
    
    # Firefox preferences (basic privacy settings)
    preferences = {
      "browser.disableResetPrompt" = true;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.startup.homepage" = "about:blank";
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
    };
  };
  
  # Set default browser associations
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}