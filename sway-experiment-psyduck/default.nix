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
