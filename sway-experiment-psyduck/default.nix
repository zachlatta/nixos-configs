{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      wl-clipboard # make wl-copy and wl-paste available in session
      mako # notification daemon

      # theme
      adwaita-qt
      gnome3.adwaita-icon-theme
    ];
  };

  # For the Sway environment, wanted packages go here.
  #
  # This should be considered temporary until the Sway environment is either
  # refactored into a broader config or killed.
  environment.systemPackages = with pkgs; [
    git
    tree

    (chromium.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-memory-buffer-video-frames"; # wayland
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

  imports = [ <home-manager/nixos> ];

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    imports = [
      ../sway-experiment-shared-home
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
      };
    };
  };
}
