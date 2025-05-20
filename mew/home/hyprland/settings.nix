{ config, pkgs, lib, inputs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = [
      "eDP-1,preferred,auto,1.5" # Example: Laptop screen with 1.5x scale
      # Add other monitors here if you have them, e.g.:
      # "DP-1,preferred,auto,1,bitdepth,10"
    ];

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more

    # Source a file (multi-file configs)
    # source = ~/.config/hypr/myColors.conf

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(ca9ee6ee) rgba(f2d5cfea) 45deg"; # Mauve + Pink
      "col.inactive_border" = "rgba(414559aa)"; # Surface0
      layout = "dwindle"; # master stack or dwindle
      allow_tearing = false; # false is recommended
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 2;
        new_optimizations = true;
        # xray = true; # See through blurred windows
      };
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section.
      preserve_split = true; # you probably want this
    };

    master = {
      new_is_master = true;
    };

    gestures = {
      workspace_swipe = true;
    };

    misc = {
      force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      # enable_swallow = true;
      # swallow_regex = "^(kitty|wezterm)$";
    };

    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1; # Focus window on hover

      touchpad = {
        natural_scroll = true;
        # disable_while_typing = true; # Not always available/working well
      };

      sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
      accel_profile = "flat";
    };

    # Configure hyprbars plugin
    plugin = {
      hyprbars = {
        bar_height = 24;
        # bar_color = "rgba(20, 20, 20, 0.8)"; # Example color
        # bar_title_font_size = 12;
        # bar_title_font_family = "JetBrainsMono Nerd Font";
        # bar_text_color = "rgb(220, 220, 220)";
        col.text = "rgb(e5e5e5)"; # Example text color for title
      };
    };
    
    # Hyprbars buttons
    "hyprbars-button" = [
      "rgb(235, 137, 137), 18, , hyprctl dispatch killactive"             # Close (fa-times)
      "rgb(138, 173, 244), 18, , hyprctl dispatch fullscreen 1"  # Maximize
      "rgb(245, 224, 179), 18, , hyprctl dispatch togglefloating"        # Float
    ];
  };
} 