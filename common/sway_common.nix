{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.gnome3.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      wl-clipboard # make wl-copy and wl-paste available in session
      mako # notification daemon

      # theme
      adwaita-qt
      gnome3.adwaita-icon-theme

      # networking
      gnome3.networkmanagerapplet
    ];
  };

  # For the Sway environment, wanted packages go here.
  #
  # This should be considered temporary until the Sway environment is either
  # refactored into a broader config or killed.
  environment.systemPackages = with pkgs; [
    tree

    (chromium.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland"; # wayland
    })
  ];

  # FONTS
  fonts.fonts = with pkgs; [
    corefonts

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-emoji-blob-bin

    dejavu_fonts
    roboto
    source-sans-pro

    nerdfonts

    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font

    proggyfonts
  ];
}
