# mew/home-manager/home.nix
{ pkgs, config, lib, inputs, unstable, ... }:

let
  hyprland-config-path = ./hyprland/hyprland.conf;
  hyprlock-config-path = ./hyprland/hyprlock.conf;
  waybar-config-path = ./hyprland/waybar/config;
  waybar-style-path = ./hyprland/waybar/style.css;
  mako-config-path = ./hyprland/mako/config;
  hyprpaper-config-path = ./hyprland/hyprpaper.conf;
in
{
  # Home Manager needs a state version.
  home.stateVersion = "24.05"; # Or your current NixOS/HM version

  home.username = "zrl";
  home.homeDirectory = "/home/zrl";

  # Symlink dotfiles managed by home-manager
  home.file.".config/hypr/hyprland.conf".source = hyprland-config-path;
  home.file.".config/hypr/hyprlock.conf".source = hyprlock-config-path;
  home.file.".config/hypr/hyprpaper.conf".source = hyprpaper-config-path;
  home.file.".config/waybar/config".source = waybar-config-path;
  home.file.".config/waybar/style.css".source = waybar-style-path;
  home.file.".config/mako/config".source = mako-config-path;

  # Make script files executable
  home.file.".config/hypr/scripts/volume_notify.sh" = {
    source = ./hyprland/scripts/volume_notify.sh;
    executable = true;
  };
  home.file.".config/hypr/scripts/brightness_notify.sh" = {
    source = ./hyprland/scripts/brightness_notify.sh;
    executable = true;
  };
  home.file.".config/hypr/scripts/portal-fix.sh" = {
    source = ./hyprland/scripts/portal-fix.sh;
    executable = true;
  };

  # Install user-specific packages
  home.packages = with pkgs; [
    # Hyprland ecosystem
    hyprpicker  # Color picker
    wl-clipboard
    cliphist
    jq # for cliphist script
    wlogout # logout menu
    swaynotificationcenter # if mako is not preferred for some reason
    
    # General utilities
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    networkmanager_dmenu # network management via dmenu/wofi
    pavucontrol
    brightnessctl
    playerctl # for media key control
    grim # screenshot
    slurp # screenshot selection

    # Themeing
    nwg-look # GTK theme configuration
    qt5ct
    qt6ct
    kdePackages.breeze-gtk # Breeze GTK theme
    kdePackages.breezeskin # Breeze Qt theme + cursors
    # gnome.adwaita-icon-theme # Already in sway for lugia, good fallback

    # Fonts (some already in systemPackages, add more specific ones here if needed)
    # pkgs.jetbrains-mono
  ];

  # Wayland and Hyprland specific configurations
  wayland.windowManager.hyprland = {
    enable = true;
    package = unstable.hyprland; # Ensure consistency with system if preferred
    xwayland.enable = true;
    # We use home.file to link hyprland.conf, so no need for settings or extraConfig here
    # unless you want to define some parts directly in Nix.
    # For a fully declarative setup with hyprland.conf, linking is good.
  };

  # Enable services
  services.mako = {
    enable = true;
    # Config is managed by home.file link
  };

  services.hyprpaper = {
    enable = true;
    # Config is managed by home.file link
  };

  # Example: Autostart Waybar (alternative to hyprland.conf exec-once)
  services.waybar = {
    enable = true;
    package = pkgs.waybar; # or unstable.waybar
    # Config and style are managed by home.file links
  };

  # Idle daemon for screen locking etc.
  services.hypridle = {
    enable = true;
    package = unstable.hypridle; # Or pkgs.hypridle
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # Safe execution
        before_sleep_cmd = "loginctl lock-session"; # Lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # Resume monitors
      };
      listener = [
        {
          timeout = 150; # 2.5 minutes
          on_timeout = "brightnessctl set 10%";
          on_resume = "brightnessctl -r";
        }
        {
          timeout = 300; # 5 minutes
          on_timeout = "hyprctl dispatch dpms off";    # Screen off
          on_resume = "hyprctl dispatch dpms on";     # Screen on
        }
        {
          timeout = 330; # 5.5 minutes
          on_timeout = "pidof hyprlock || hyprlock";   # Lock screen
        }
        {
          timeout = 600; # 10 minutes
          on_timeout = "loginctl suspend";            # Suspend
        }
      ];
    };
  };

  # GTK Themeing
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    theme = {
      name = "Breeze-Dark"; # Example, ensure breeze-gtk is installed
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "breeze-dark"; # Example
      package = pkgs.kdePackages.breeze;
    };
    cursorTheme = {
      name = "Breeze_Snow"; # Or Breeze_Light, Breeze_Dark
      package = pkgs.kdePackages.breezeskin; # Breeze cursors are often in breeze or breezeskin
      size = 24;
    };
  };

  # Qt Themeing (optional, if you use Qt apps)
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # or "gtk" for gtk2 style
    style = {
      name = "Breeze"; # Match GTK
      package = pkgs.kdePackages.breezeskin; # Provides Breeze Qt style
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim"; # Or your preferred editor
    BROWSER = "firefox";
    TERMINAL = "kitty"; # Already in systemPackages

    # These are also in your system NixOS config, ensure no conflicts or decide where to manage them.
    # WLR_NO_HARDWARE_CURSORS = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # LIBVA_DRIVER_NAME = "nvidia";
    # NVD_BACKEND = "direct"; # For some newer NVIDIA features with NVK
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # For zsh specific config
  programs.zsh = {
    enable = true;
    # ... your zsh config ...
  };
  
  # Neovim (example, adapt if you have it elsewhere)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
} 