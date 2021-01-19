{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    killall
    file

    wget
    vim
    tree
    git
    youtube-dl

    okular
    gwenview
    ark
    ktorrent

    firefox
    (google-chrome.override {
      commandLineArgs = "--disable-frame-rate-limit";
    })
    slack
    blender
    vscodium
    virt-manager
    spotify
    zoom-us
    libreoffice
    celluloid

    gparted

    snapper

    tailscale

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
