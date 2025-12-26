# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix

      # Home Manager
      ./modules/home-manager

      # Development modules
      ./modules/development/tools.nix
      ./modules/development/languages.nix
      ./modules/development/direnv.nix
      ./modules/development/databases.nix
      # ./modules/development/neovim.nix  # Moved to Home Manager
      ./modules/development/productivity.nix

      # Desktop modules
      ./modules/desktop/desktop-selector.nix  # Desktop environment switcher
      ./modules/desktop/browsers.nix
      ./modules/desktop/applications.nix
      ./modules/desktop/fonts-themes.nix
      ./modules/desktop/gaming.nix
      ./modules/desktop/steam-vulkan-fix.nix  # Fix for Steam Vulkan/DirectX issues

      # Hardware
      ./modules/hardware/bluetooth.nix
      ./modules/hardware/gpu-acceleration.nix  # AMD GPU hardware acceleration

      # Services
      ./modules/services/docker.nix
      ./modules/services/ssh.nix
      ./modules/services/vpn.nix
      ./modules/services/clamav.nix

      # System
      ./modules/system/auto-update-flakes.nix

      # Security
      ./modules/security/hardening.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    # Store WiFi passwords unencrypted to bypass KDE Wallet requirement
    wifi.backend = "iwd";  # Alternative: use iwd backend which doesn't use wallet
  };
  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Desktop environments are now managed in desktop-selector module
  # Edit modules/desktop/desktop-selector.nix to enable/disable desktop environments

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,us";
    variant = ",colemak";
    options = "grp:win_space_toggle";
  };

  # Enable uinput for virtual input devices (needed by kanata)
  hardware.uinput.enable = true;

  # Key remapping for both X11 and Wayland using kanata
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = [ ];  # Empty = auto-detect all keyboards
      config = ''
        (defsrc
          caps bspc
        )
        (deflayer default
          bspc caps
        )
      '';
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;  # Enable JACK compatibility
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.dom = {
    isNormalUser = true;
    description = "Dominic";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Allow mutable users to set passwords after installation
  users.mutableUsers = lib.mkForce true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dom";

  # Install firefox.
  programs.firefox.enable = true;

  # Enable AppImage support
  programs.appimage = {
    enable = true;
    binfmt = true;  # Register AppImage files to run directly
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  wget
  pkgs.kdePackages.ffmpegthumbs
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

    # Create /bin/bash symlink for compatibility (needed by Claude Code's Chrome integration)
  # Create /usr/bin/node symlink so Claude Code MCP servers find nix's node before fnm's
  system.activationScripts.binCompatibility = ''
    mkdir -p /bin /usr/bin
    ln -sf ${pkgs.bash}/bin/bash /bin/bash
    ln -sf ${pkgs.nodejs_24}/bin/node /usr/bin/node
  '';

  # Enable flakes and new nix command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
