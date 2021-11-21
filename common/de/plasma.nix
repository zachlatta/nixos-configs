{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.dpi = 163;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.supportDDC =
    true; # For external brightness control

  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  environment.systemPackages = with pkgs; [
    powerdevil # needed for brightness control

    killall
    file

    wget
    htop
    glances
    vim
    tree
    git

    youtube-dl

    okular
    gwenview
    ark

    google-chrome

    slack
    blender
    vscode

    virt-manager

    spotify

    zoom-us
    celluloid

    _1password-gui

    alacritty

    gparted
  ];
}
