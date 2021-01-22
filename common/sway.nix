{ config, lib, pkgs, ... }:

{
  # Try out Sway. This is used in Lugia. Should be moved.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      gnome3.networkmanagerapplet # For networking
    ];
  };
}
