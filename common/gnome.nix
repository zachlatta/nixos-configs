{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  services.dbus.packages = with pkgs; [ gnome2.GConf ];

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome3.adwaita-icon-theme
    gnomeExtensions.appindicator

    chromium
  ];

  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
