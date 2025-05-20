{ inputs, pkgs, config, lib, ... }:

let
  mod = "SUPER"; # SUPER (Windows) key
in
{
  imports = [
    ./settings.nix
    ./keybinds.nix
    ./windowrules.nix
    ./autostart.nix # For user-specific autostart items
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # Use extraConfig for direct hyprland.conf configuration instead of structured settings
    extraConfig = ''
      # This is a simpler approach that avoids potential module compatibility issues
      # Monitor configuration
      monitor=eDP-1,preferred,auto,1.5
      
      # General settings
      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(ca9ee6ee) rgba(f2d5cfea) 45deg
        col.inactive_border = rgba(414559aa)
        layout = dwindle
      }

      # Decoration
      decoration {
        rounding = 10
        blur {
          enabled = true
          size = 3
          passes = 2
        }
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
      }

      # Input configuration
      input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
          natural_scroll = true
        }
        sensitivity = 0
        accel_profile = flat
      }

      # Plugin configuration
      plugin {
        hyprbars {
          bar_height = 24
          col.text = rgb(e5e5e5)
        }
      }
      
      # Hyprbars buttons
      hyprbars-button = rgb(235, 137, 137), 18, , hyprctl dispatch killactive
      hyprbars-button = rgb(138, 173, 244), 18, , hyprctl dispatch fullscreen 1
      hyprbars-button = rgb(245, 224, 179), 18, , hyprctl dispatch togglefloating
    '';
  };

  # Session variables specific to Hyprland session if needed,
  # but most are handled system-wide.
  # home.sessionVariables = {
  #   XCURSOR_THEME = config.gtk.cursorTheme.name;
  #   XCURSOR_SIZE = toString config.gtk.cursorTheme.size;
  # };
} 