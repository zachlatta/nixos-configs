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

        "DP-1" = {
          mode = "3840x2160@120Hz";
        };

        "DP-2" = {
          transform = "270";
        };
      };
    };
  };
}
