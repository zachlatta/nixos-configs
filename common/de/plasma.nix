{ config, pkgs, ... }:

let
  #typora = pkgs.callPackage ../../pkgs/typora { };
  #logbook = pkgs.callPackage ../../pkgs/custom/logbook { };
  close-windows = pkgs.callPackage ../../pkgs/custom/close-windows { };

  gopro-as-webcam = pkgs.callPackage ../../pkgs/gopro-as-webcam { };
in {
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

    okular
    gwenview
    ark

    google-chrome

    slack
    blender
    vscode

    virt-manager

    standardnotes
    simplenote
    obsidian
    zoom-us
    celluloid
    losslesscut-bin

    _1password-gui

    alacritty

    gparted

    close-windows

    gopro-as-webcam
  ];
}
