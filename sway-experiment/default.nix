{ config, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      bemenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      gnome3.networkmanagerapplet # For networking
    ];
  };

  imports = [ <home-manager/nixos> ];

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    programs.bash.enable = true;

    programs.git = {
      enable = true;
      userName = "Zach Latta";
      userEmail = "zach@zachlatta.com";

      ignores = [
# Vim files
''
# Swap
[._]*.s[a-v][a-z]
!*.svg  # comment out if you don't need vector files
[._]*.sw[a-p]
[._]s[a-rt-v][a-z]
[._]ss[a-gi-z]
[._]sw[a-p]

# Session
Session.vim
Sessionx.vim

# Temporary
.netrwhist
*~
# Auto-generated tag files
tags
# Persistent undo
[._]*.un~
''
      ];
    };

    # warning: this might be overriding the system installed sway
    wayland.windowManager.sway = {
      enable = true;

      config = {
        terminal = "${pkgs.alacritty}/bin/alacritty";

        menu = "${pkgs.bemenu}/bin/bemenu-run -m all --no-exec | xargs swaymsg exec --";
      };
    };
  };
}
