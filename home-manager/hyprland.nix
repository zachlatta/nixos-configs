{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    # use the ones from the nixos module, per hyprland docs
    package = null;
    portalPackage = null;
    settings = {
      monitor          = ",preferred,auto,1.5";     # global 150 % scale
      exec-once        = [
        "waybar"                       # bar
        "swww init && swww img ~/Pictures/wall.jpg"
      ];

      # keybinds ----------------------------------------------------------
      "$mod" = "SUPER";                # easier to read later
      bind = [
        "$mod,Return,exec,alacritty"
        "$mod,d,exec,wofi --show drun"
        "$mod,space,togglefloating"
        "$mod,Shift,Q,killactive"
        "$mod,f,fullscreen"
        "$mod,Print,exec,grim -g \"$(slurp)\" - | wl-copy"
      ];
    };
  };
} 
