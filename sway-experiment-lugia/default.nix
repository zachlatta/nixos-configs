{ config, pkgs, lib, ... }:

{
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
