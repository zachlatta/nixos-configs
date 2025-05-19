# mew/home-manager/home.nix
{ pkgs, config, lib, inputs, unstable, ... }:

let
  # Use separate location for hyprland configuration
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
  # Removed hyprland.conf which was causing conflict
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
    waybar  # Include waybar as a package instead of a service
    mako    # Include mako as a package instead of a service
    libnotify # For notify-send
    
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
    libsForQt5.qt5ct # Fixed package name
    kdePackages.breeze-gtk # Breeze GTK theme
    kdePackages.breeze # Breeze Qt theme + cursors
    # gnome.adwaita-icon-theme # Already in sway for lugia, good fallback

    # Fonts (some already in systemPackages, add more specific ones here if needed)
    # pkgs.jetbrains-mono
  ];

  # Wayland and Hyprland specific configurations
  wayland.windowManager.hyprland = {
    enable = true;
    package = unstable.hyprland; # Ensure consistency with system if preferred
    xwayland.enable = true;
    systemd.enable = true; # Enable systemd integration
    
    # Let Home Manager manage hyprland.conf directly
    # We'll read our file and use it as extraConfig
    extraConfig = builtins.readFile ./hyprland/hyprland.conf;
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
      package = pkgs.kdePackages.breeze; # Changed from breezeskin to breeze
      size = 24;
    };
  };

  # Qt Themeing (optional, if you use Qt apps)
  qt = {
    enable = true;
    platformTheme = "qtct"; # Changed from qt5ct to qtct
    style = {
      name = "Breeze"; # Match GTK
      package = pkgs.kdePackages.breeze; # Changed from breezeskin to breeze
    };
  };

  # Home variables (environment variables for the user)
  home.sessionVariables = {
    EDITOR = "nvim"; # Or your preferred editor
    BROWSER = "firefox";
    TERMINAL = "kitty"; # Already in systemPackages
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