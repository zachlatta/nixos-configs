{ pkgs, ... }:

let
  # Define these directly here instead of referencing from config
  hyprland-cursor-name = "Adwaita";
  hyprland-cursor-size = 24;
in
{
  # Using extraConfig for exec-once commands
  wayland.windowManager.hyprland.extraConfig = ''
    # Set cursor theme for Hyprland
    exec-once = hyprctl setcursor ${hyprland-cursor-name} ${toString hyprland-cursor-size}
    
    # Start NetworkManager applet
    exec-once = nm-applet --indicator
  '';
} 