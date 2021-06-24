{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.dpi = 163;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.supportDDC = true; # For external brightness control

  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  environment.systemPackages = with pkgs; [
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
    ktorrent

    chromium
    google-chrome

    slack
    blender
    vscodium
    virt-manager
    spotify
    zoom-us
    libreoffice
    celluloid
    krita

    alacritty

    gparted

    snapper

    tdesktop

    # emacs + dependencies for doom
    emacs
    ripgrep
    coreutils
    fd

    obs-studio

    barrier
    synergy
  ];

  # expose barrier in firewall
  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking.firewall.allowedUDPPorts = [ 24800 ];

  # obs v4l2sink for virtual OBS webcam
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
  '';
}
