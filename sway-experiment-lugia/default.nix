{ config, pkgs, lib, ... }:

{
  imports = [
    ../common/sway_common.nix

    <home-manager/nixos>
  ];

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    imports = [
      ../home-manager
    ];

    wayland.windowManager.sway.config = {
      modifier = "Mod4";

      output = {
        "*" = {
          scale = "1.5";
        };

        "DP-2" = {
          mode = "3840x2160@60Hz";
          transform = "270";
          pos = "0 0";
        };

        "DP-1" = {
          mode = "3840x2160@120Hz";
          pos = "1440 600";
        };
      };

      input = {
        "1133:16514:Logitech_MX_Master_3" = {
          accel_profile = "adaptive";
          pointer_accel = "0.25";
        };
      };
    };
  };
}
