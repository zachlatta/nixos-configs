{ pkgs, ... }:

let
  mod = "SUPER"; # SUPER (Windows) key
  terminal = "${pkgs.kitty}/bin/kitty"; # Or your preferred terminal
  launcher = "${pkgs.wofi}/bin/wofi --show drun";
  browser = "${pkgs.firefox}/bin/firefox"; # Or your preferred browser
  fileManager = "${pkgs.dolphin}/bin/dolphin";
  lockScreen = "${pkgs.hyprlock}/bin/hyprlock";
  logoutMenu = "${pkgs.wlogout}/bin/wlogout -p layer-shell"; # Ensure wlogout is configured
  screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png && ${pkgs.libnotify}/bin/notify-send 'Screenshot copied!'";
  screenshot_fullscreen = "${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png && ${pkgs.libnotify}/bin/notify-send 'Fullscreen Screenshot copied!'";

in
{
  # This file will add to extraConfig
  wayland.windowManager.hyprland.extraConfig = ''
    # Key bindings
    bind = ${mod}, RETURN, exec, ${terminal}
    bind = ${mod}, D, exec, ${launcher}
    bind = ${mod}, E, exec, ${fileManager}
    bind = ${mod}, B, exec, ${browser}

    # Window management
    bind = ${mod}, Q, killactive
    bind = ${mod}, M, exit # Exit Hyprland (warning: will close session)
    bind = ${mod}, F, fullscreen
    bind = ${mod}, SPACE, togglefloating
    bind = ${mod}, P, pseudo # dwindle
    bind = ${mod}, J, togglesplit # dwindle

    # Move focus with mod + arrow keys
    bind = ${mod}, left, movefocus, l
    bind = ${mod}, right, movefocus, r
    bind = ${mod}, up, movefocus, u
    bind = ${mod}, down, movefocus, d

    # Switch workspaces
    bind = ${mod}, 1, workspace, 1
    bind = ${mod}, 2, workspace, 2
    bind = ${mod}, 3, workspace, 3
    bind = ${mod}, 4, workspace, 4
    bind = ${mod}, 5, workspace, 5
    bind = ${mod}, 6, workspace, 6
    bind = ${mod}, 7, workspace, 7
    bind = ${mod}, 8, workspace, 8
    bind = ${mod}, 9, workspace, 9
    bind = ${mod}, 0, workspace, 10

    # Move active window to workspace
    bind = ${mod} SHIFT, 1, movetoworkspace, 1
    bind = ${mod} SHIFT, 2, movetoworkspace, 2
    bind = ${mod} SHIFT, 3, movetoworkspace, 3
    bind = ${mod} SHIFT, 4, movetoworkspace, 4
    bind = ${mod} SHIFT, 5, movetoworkspace, 5
    bind = ${mod} SHIFT, 6, movetoworkspace, 6
    bind = ${mod} SHIFT, 7, movetoworkspace, 7
    bind = ${mod} SHIFT, 8, movetoworkspace, 8
    bind = ${mod} SHIFT, 9, movetoworkspace, 9
    bind = ${mod} SHIFT, 0, movetoworkspace, 10

    # Scroll through workspaces
    bind = ${mod}, mouse_down, workspace, e+1
    bind = ${mod}, mouse_up, workspace, e-1

    # System controls
    bind = ${mod} SHIFT, L, exec, ${lockScreen}
    bind = ${mod} SHIFT, E, exec, ${logoutMenu}

    # Screenshots
    bind = , Print, exec, ${screenshot_fullscreen}
    bind = SHIFT, Print, exec, ${screenshot}

    # Volume and media controls
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPrev, exec, playerctl previous
    
    # Mouse bindings
    bind = ${mod}, mouse:272, movewindow
    bind = ${mod}, mouse:273, resizewindow
  '';
} 