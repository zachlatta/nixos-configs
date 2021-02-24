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

    # obs + v4l2sink for virtual OBS webcam
    #
    # need to manually run the following after installing (apparently nixos doesn't support obs hooks or something)
    #
    # ln -s `nix-build '<nixpkgs>' -A obs-v4l2sink --no-out-link`/share/obs/obs-plugins/v4l2sink ~/.config/obs-studio/plugins/v4l2sink
    obs-studio
    obs-v4l2sink
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label="obs"
  '';

  # open port for spotify so it can sync with local devices on same network
  networking.firewall.allowedTCPPorts = [ 57621 ];
}
