{ pkgs, config, inputs, ... }:

let
  # Use an absolute path that doesn't rely on config
  wallpaperPath = "/home/zrl/Pictures/Wallpapers/default.png";
in
{
  # Hyprpaper configuration via config file instead of service
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = ,${wallpaperPath}
    ipc = off
    splash = false
  '';

  # Hypridle configuration via config file instead of service
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
      lock_cmd = "${inputs.hyprlock.packages.${pkgs.system}.default}/bin/hyprlock"
      unlock_cmd = "${pkgs.libnotify}/bin/notify-send 'Screen Unlocked'"
      before_sleep_cmd = "${pkgs.libnotify}/bin/notify-send 'System Going to Sleep'"
      after_sleep_cmd = "hyprctl dispatch dpms on"
    }

    listener {
      timeout = 300
      on-timeout = "${inputs.hyprlock.packages.${pkgs.system}.default}/bin/hyprlock"
    }

    listener {
      timeout = 330
      on-timeout = "hyprctl dispatch dpms off"
      on-resume = "hyprctl dispatch dpms on"
    }
  '';

  # Hyprlock configuration via config file
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        disable_loading_bar = true
        hide_cursor = true
        grace = 10 # seconds before locking due to no input
        no_fade_in = false
    }

    background {
        path = ${wallpaperPath}
        blur_passes = 3
        blur_size = 8
        noise = 0.01
        contrast = 1.0
        brightness = 0.8
        vibrancy = 0.1
        vibrancy_darkness = 0.0
    }

    input-field {
        size = 250, 50
        position = 0, -80 # Offset from center
        halign = center
        valign = center

        outline_thickness = 2
        dots_size = 0.25
        dots_spacing = 0.2
        dots_center = true
        
        # Catppuccin Mocha Colors
        outer_color = rgb(8883f5)   # Mauve
        inner_color = rgb(1e1e2e)   # Base
        font_color = rgb(cdd6f4)    # Text
        fade_on_empty = true
        placeholder_text = <i>Password...</i>
        
        check_color = rgb(a6e3a1)   # Green
        fail_color = rgb(f38ba8)    # Red
        fail_text = <i>Login Failed!</i>
        fail_transition = 300
        capslock_color = rgb(fab387) # Peach
    }

    label { # Clock
        text = cmd[date +%H:%M]
        color = rgba(205, 214, 244, 1.0) # Text
        font_size = 80
        font_family = JetBrainsMono Nerd Font Bold
        position = 0, 100 # Offset from center
        halign = center
        valign = center
        shadow_passes = 1
        shadow_size = 3
        shadow_color = rgb(181b2c) # Crust
    }

    label { # Date / User Info
        text = cmd[date +%A, %d %B %Y]
        color = rgba(186, 194, 222, 0.8) # Subtext0
        font_size = 18
        font_family = JetBrainsMono Nerd Font
        position = 0, -40 # Offset from clock
        halign = center
        valign = center
        shadow_passes = 1
        shadow_size = 2
        shadow_color = rgb(181b2c)
    }
  '';

  # Add a simple systemd user service for autostart
  systemd.user.services = {
    hyprpaper = {
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
  };
} 