{ config, pkgs, lib, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # use plasma5 applications (dolphin, keyring, etc). just make sure to log into sway session.
  services.xserver.desktopManager.plasma5.enable = true;

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
  environment.systemPackages =
  let
    chromiumArgs = if config.networking.hostName == "psyduck"
      # run in wayland + fix video playback (i think this makes it do cpu rendering)
      then "--enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-memory-buffer-video-frames"
      # run in wayland
      else "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  in
  with pkgs; [
    tree
    ripgrep

    virt-manager

    pcmanfm

    zoom-us

    (chromium.override {
      commandLineArgs = chromiumArgs;
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

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    imports = [
      ../../home-manager
    ];

    wayland.windowManager.sway.config = {
      modifier = "Mod4";

      output = {
        "*" = {
          scale = "1.5";
        };
      };

      input = {
        # built-in laptop keyboard
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_options = "altwin:swap_lalt_lwin"; # swap windows key with left alt key
        };

        # external logitech bluetooth keyboard at home
        "1133:45890:Keyboard_K380_Keyboard" = {
          xkb_options = "altwin:swap_lalt_lwin"; # swap windows key with left alt key
        };
      };
    };
  };
}
