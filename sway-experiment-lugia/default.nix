{ config, pkgs, lib, ... }:

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

      j4-dmenu-desktop # For feeding .desktop files into bemenu
      bemenu # Dmenu is the default in the config but i recommend wofi since its wayland native

      gnome3.networkmanagerapplet # For networking
      brightnessctl
      pamixer
      wob
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

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-nix ];
      settings = {
        expandtab = true;
        shiftwidth = 2;
        number = true;
      };
    };

    wayland.windowManager.sway =
    # warning: this might be overriding the system installed sway binary
    let
      swaymsg = "${pkgs.sway}/bin/swaymsg";

      alacritty = "${pkgs.alacritty}/bin/alacritty";
      bemenu = "${pkgs.bemenu}/bin/bemenu";
      gtk-launch = "${pkgs.gnome3.gtk}/bin/gtk-launch";
      j4-dmenu-desktop = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop";
      wob = "${pkgs.wob}/bin/wob";

      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      brightnessIncrement = "8";

      pamixer = "${pkgs.pamixer}/bin/pamixer";
      audioIncrement = "10";

      cut = "${pkgs.coreutils}/bin/cut";
      head = "${pkgs.coreutils}/bin/head";
      mkfifo = "${pkgs.coreutils}/bin/mkfifo";
      sed = "${pkgs.gnused}/bin/sed";
      tail = "${pkgs.coreutils}/bin/tail";
    in
    {
      enable = true;

      config = {
        output = {
          "*" = {
            scale = "1.5";
          };
        };

        terminal = "${alacritty}";

        menu = "${j4-dmenu-desktop} --dmenu='${bemenu} -i' --term='${alacritty}'";

        startup = [
          { command = "${mkfifo} $SWAYSOCK.wob && ${tail} -f $SWAYSOCK.wob | ${wob}"; }
        ];

        keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Shift+Return" = "exec '${gtk-launch} chromium-browser-wayland.desktop'";
          "${mod}+Ctrl+Return" = "exec '${gtk-launch} roam-research-wayland.desktop'";

          "XF86MonBrightnessUp" = ''exec "${brightnessctl} -e set ${brightnessIncrement}%+ && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';
          "XF86MonBrightnessDown" = ''exec "${brightnessctl} -e set ${brightnessIncrement}%- && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';

          "XF86AudioRaiseVolume" = "exec '${pamixer} -ui ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
          "XF86AudioLowerVolume" = "exec '${pamixer} -ud ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
          "XF86AudioMute" = "exec ${pamixer} --toggle-mute && ( ${pamixer} --get-mute && echo 0 > $SWAYSOCK.wob ) || ${pamixer} --get-volume > $SWAYSOCK.wob";
        };
      };
    };
  };
}
