{ pkgs, config, lib, inputs, ... }:

{
  imports = [
    ./hyprland/default.nix
  ];

  # Basic configuration
  home = {
    username = "zrl";
    homeDirectory = "/home/zrl";
    stateVersion = "24.11";
    
    packages = with pkgs; [
      # Wayland tools
      mako          # Notification daemon
      wlogout       # Logout menu
      wofi          # Application launcher
      wl-clipboard  # Clipboard utilities
      slurp         # Region selection
      grim          # Screenshot utility
      brightnessctl # For brightness keybindings
      playerctl     # For media keybindings
      networkmanagerapplet # For nm-applet in autostart
      
      # Fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FontAwesome" ]; })
      font-awesome # For icons
      
      # Hyprland tools (moved from system packages to user packages)
      inputs.hyprpaper.packages.${pkgs.system}.default # Wallpaper
      inputs.hyprlock.packages.${pkgs.system}.default  # Lock screen
      inputs.hypridle.packages.${pkgs.system}.default  # Idle daemon
    ];
  };
  
  # Wayland settings for Hyprland
  wayland.windowManager.hyprland.enable = true;
  
  # XDG user directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    templates = null;
    publicshare = null;
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
  };
  
  # Configuration files
  xdg.configFile = {
    # Mako notification daemon
    "mako/config".text = ''
      font=JetBrainsMono Nerd Font 10
      width=350
      height=100
      padding=10
      border-size=2
      border-radius=5
      default-timeout=5000
      background-color=#282a36dd
      border-color=#bd93f9dd
      text-color=#f8f8f2dd
    '';
    
    # Hyprpaper wallpaper daemon
    "hypr/hyprpaper.conf".text = ''
      preload = /home/zrl/Pictures/Wallpapers/default.png
      wallpaper = ,/home/zrl/Pictures/Wallpapers/default.png
      ipc = off
      splash = false
    '';
    
    # Hyprlock screen locker
    "hypr/hyprlock.conf".text = ''
      general {
          disable_loading_bar = true
          hide_cursor = true
      }

      background {
          path = /home/zrl/Pictures/Wallpapers/default.png
          blur_passes = 3
      }

      input-field {
          size = 250, 50
          position = 0, -80
          halign = center
          valign = center
      }
    '';
    
    # Hypridle daemon
    "hypr/hypridle.conf".text = ''
      general {
        lock_cmd = ${lib.escapeShellArg "${inputs.hyprlock.packages.${pkgs.system}.default}/bin/hyprlock"}
      }

      listener {
        timeout = 300
        on-timeout = ${lib.escapeShellArg "${inputs.hyprlock.packages.${pkgs.system}.default}/bin/hyprlock"}
      }
    '';
  };
  
  # Fonts
  fonts.fontconfig.enable = true;
  
  # Wofi application launcher
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
    };
  };
  
  # Hyprland autostart service
  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprland wallpaper daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${inputs.hyprpaper.packages.${pkgs.system}.default}/bin/hyprpaper";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
} 