# modules/home-manager/browsers.nix - Browser configurations
{ config, pkgs, lib, ... }:

{
  # Browser packages
  home.packages = with pkgs; [
    # Browsers
    brave
    google-chrome
    # chromium is configured via programs.chromium below
    
    # Browser tools
    browserpass  # Password manager integration
    # tridactyl-native  # Vim-like browser navigation (for Firefox)
  ];
  
  # Firefox configuration
  # Note: Firefox is installed at system level, but we can configure user profiles
  programs.firefox = {
    enable = true;  # This creates user profiles even if Firefox is system-installed
    
    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "default";
        
        # Firefox preferences
        settings = {
          # Privacy settings
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.resistFingerprinting" = false;  # Can break some sites
          
          # Security
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          
          # Search
          "browser.search.suggest.enabled" = false;
          "browser.search.region" = "US";
          "browser.search.isUS" = true;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          
          # Telemetry
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          
          # Performance
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "layers.acceleration.force-enabled" = true;
          
          # UI Customization
          "browser.startup.homepage" = "https://start.duckduckgo.com";
          "browser.startup.page" = 1;  # 0=blank, 1=home, 2=last, 3=resume
          "browser.newtabpage.enabled" = true;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          
          # Downloads
          "browser.download.useDownloadDir" = false;  # Always ask where to save
          "browser.download.manager.addToRecentDocs" = false;
          
          # Misc
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "browser.tabs.warnOnCloseOtherTabs" = false;
          "browser.warnOnQuit" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "extensions.pocket.enabled" = false;
          "identity.fxaccounts.enabled" = false;  # Disable Firefox Sync
          "signon.rememberSignons" = false;  # Use external password manager
          
          # Developer tools
          "devtools.theme" = "dark";
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
        };
        
        # Search engines
        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          
          engines = {
            "google".metaData.hidden = true;
            "bing".metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
            "ebay".metaData.hidden = true;
            
            "ddg" = {
              urls = [{
                template = "https://duckduckgo.com";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://duckduckgo.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;  # Daily
              definedAliases = [ "@ddg" ];
            };
            
            "Searx" = {
              urls = [{
                template = "https://searx.be/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://searx.be/favicon.ico";
              definedAliases = [ "@sx" ];
            };
            
            "Wikipedia" = {
              urls = [{
                template = "https://en.wikipedia.org/wiki/Special:Search";
                params = [
                  { name = "search"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://en.wikipedia.org/favicon.ico";
              definedAliases = [ "@wiki" ];
            };
            
            "GitHub" = {
              urls = [{
                template = "https://github.com/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://github.com/favicon.ico";
              definedAliases = [ "@gh" ];
            };
            
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nix" ];
            };
            
            "youtube" = {
              urls = [{
                template = "https://www.youtube.com/results";
                params = [
                  { name = "search_query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://www.youtube.com/favicon.ico";
              definedAliases = [ "@yt" ];
            };
          };
        };
        
        # Extensions - removed, Firefox is only backup browser
        
        # Bookmarks
        bookmarks = {
          force = true;
          settings = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "GitHub";
                url = "https://github.com";
              }
              {
                name = "NixOS Search";
                url = "https://search.nixos.org";
              }
              {
                name = "Home Manager Options";
                url = "https://nix-community.github.io/home-manager/options.html";
              }
              {
                name = "Dev";
                bookmarks = [
                  {
                    name = "Hacker News";
                    url = "https://news.ycombinator.com";
                  }
                  {
                    name = "Lobsters";
                    url = "https://lobste.rs";
                  }
                  {
                    name = "Dev.to";
                    url = "https://dev.to";
                  }
                ];
              }
            ];
          }
        ];
        };
      };
      
      # Work profile (example)
      work = {
        id = 1;
        name = "work";
        isDefault = false;
        
        settings = {
          "browser.startup.homepage" = "about:blank";
          "privacy.trackingprotection.enabled" = true;
          "signon.rememberSignons" = false;
        };
      };
    };
  };
  
  # Chromium configuration
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    
    # Command line flags
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-speech-api"
      "--disable-smart-virtual-keyboard"
    ];
    
    # Extensions
    extensions = [
      # Enpass Password Manager
      { id = "kmcfomidfpdkfieipokbalgegidffkal"; }
      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      # Dark Reader
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      # Vimium
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
      # SponsorBlock for YouTube
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      # Return YouTube Dislike
      { id = "gebbhagfogifgggkldgodflihgfeippi"; }
      # I don't care about cookies
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; }
      # Privacy Badger
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; }
      # Decentraleyes
      { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; }
      # ClearURLs - Removed from Chrome Web Store in 2022
      # { id = "lckanjgmijmafbedllaakclkaicjfmnk"; }
    ];
  };
  
  # Brave browser settings (via environment variables and flags file)
  home.file.".config/brave-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
    --enable-wayland-ime
    --disable-features=UseChromeOSDirectVideoDecoder
    --password-store=basic
    --disable-speech-api
  '';
  
  # Brave extension policy (same extensions as Chromium)
  # Note: Brave manages extensions via policy files like Chromium
  home.file.".config/BraveSoftware/Brave-Browser/policies/managed/extensions.json".text = builtins.toJSON {
    ExtensionInstallForcelist = [
      "kmcfomidfpdkfieipokbalgegidffkal"  # Enpass Password Manager
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"  # uBlock Origin
      "eimadpbcbfnmbkopoojfekhnkhdbieeh"  # Dark Reader
      "dbepggeogbaibhgnhhndojpepiihcmeb"  # Vimium
      "mnjggcdmjocbbbhaepdhchncahnbgone"  # SponsorBlock for YouTube
      "gebbhagfogifgggkldgodflihgfeippi"  # Return YouTube Dislike
      "fihnjjcciajhdojfnbdddfaoknhalnja"  # I don't care about cookies
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"  # Privacy Badger
      "ldpochfccmkkmhdbclfhpagapcfdljkj"  # Decentraleyes
      # "lckanjgmijmafbedllaakclkaicjfmnk"  # ClearURLs - Removed from Chrome Web Store in 2022
    ];
  };
  
  # Browser environment variables
  home.sessionVariables = {
    # Default browser
    BROWSER = "brave";
    
    # Chromium/Electron Wayland support
    NIXOS_OZONE_WL = "1";
    
    # Firefox Wayland support
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    
    # Hardware acceleration
    MOZ_WEBRENDER = "1";
    MOZ_ACCELERATED = "1";
  };
  
  # XDG MIME associations moved to xdg.nix
}