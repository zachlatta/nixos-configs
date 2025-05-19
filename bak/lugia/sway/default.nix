{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  pkgs-nightly = (import (builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {
      config.allowUnfree = true;
    });
in {
  imports = [ (import "${home-manager}/nixos") ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # encourage electron-based apps to use wayland support where available
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs;
      [
        wl-clipboard # make wl-copy and wl-paste available in session
        mako # notification daemon

        # theme
        adwaita-qt
        gnome3.adwaita-icon-theme

        # networking
        networkmanagerapplet
      ] ++ builtins.filter lib.isDerivation
      (builtins.attrValues plasma5Packages.kdeGear)
      ++ builtins.filter lib.isDerivation
      (builtins.attrValues plasma5Packages.kdeFrameworks);
  };

  # For the Sway environment, wanted packages go here.
  #
  # This should be considered temporary until the Sway environment is either
  # refactored into a broader config or killed.
  environment.systemPackages = let
    chromiumArgs =
      "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  in with pkgs; [
    arandr

    virt-manager

    pavucontrol

    pcmanfm

    zoom-us

    # get the nightly version of obsidian, which has wayland support, because the version in 22.11 doesn't as of 2023-01-11
    pkgs-nightly.obsidian

    (chromium.override { commandLineArgs = chromiumArgs; })
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
    dina-font

    proggyfonts
  ];

  home-manager.users.zrl = { pkgs, config, ... }: {
    home.packages = [ ];

    programs.home-manager.enable = true;

    imports = [ ../../home-manager ];

    wayland.windowManager.sway = let
      swaymsg = "${pkgs.sway}/bin/swaymsg";

      alacritty = "${pkgs.alacritty}/bin/alacritty";
      dolphin = "${pkgs.dolphin}/bin/dolphin";

      bemenu = "${pkgs.bemenu}/bin/bemenu";
      grim = "${pkgs.grim}/bin/grim";
      gtk-launch = "${pkgs.gtk4.dev}/bin/gtk4-launch";
      j4-dmenu-desktop = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop";
      slurp = "${pkgs.slurp}/bin/slurp";
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";

      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      brightnessIncrement = "10";

      pamixer = "${pkgs.pamixer}/bin/pamixer";
      audioIncrement = "10";
      smallAudioIncrement = "5";

      nm-applet = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      wob = "${pkgs.wob}/bin/wob";

      cat = "${pkgs.coreutils}/bin/cat";
      cut = "${pkgs.coreutils}/bin/cut";
      date = "${pkgs.coreutils}/bin/date";
      echo = "${pkgs.coreutils}/bin/echo";
      head = "${pkgs.coreutils}/bin/head";
      ls = "${pkgs.coreutils}/bin/ls";
      mkfifo = "${pkgs.coreutils}/bin/mkfifo";
      sed = "${pkgs.gnused}/bin/sed";
      sh = "${pkgs.bash}/bin/sh";
      tail = "${pkgs.coreutils}/bin/tail";
    in {
      enable = true;

      config = {
        modifier = "Mod4";

        output = {
          "*" = { scale = "1.5"; };

          "DP-1" = {
            adaptive_sync = "on";
            mode = "3840x2160@119.999Hz";
          };
        };

        input = {
          # built-in laptop keyboard
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_options =
              "altwin:swap_lalt_lwin"; # swap windows key with left alt key
          };

          "5426:123:Razer_Razer_Viper_Ultimate_Dongle" = {
            pointer_accel = "-0.7";
          };
        };

        terminal = "${alacritty}";

        # j4-dmenu-desktop needs to be wrapped with bash to properly launch
        # programs when fish is set as the default shell
        menu =
          "SHELL=${sh} ${j4-dmenu-desktop} --dmenu='${bemenu} -i -m all' --term=${alacritty}";

        startup = [
          {
            command =
              "${mkfifo} $SWAYSOCK.wob && ${tail} -f $SWAYSOCK.wob | ${wob}";
          }
          { command = "${nm-applet} --indicator"; }
        ];

        keybindings =
          let mod = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
            "${mod}+Shift+Return" = "exec '${gtk-launch} firefox.desktop'";
            "${mod}+Shift+f" = "exec ${dolphin}";

            "${mod}+Shift+4" = ''
              exec OUTPUT=$HOME/Pictures/Screenshots/$(${date} +"%Y-%m-%d %H:%M:%S").png && ${grim} -g "$(${slurp})" "$OUTPUT" && cat "$OUTPUT" | ${wl-copy} --type image/png'';

            "XF86MonBrightnessUp" = ''
              exec "${ls} /sys/class/backlight/ | xargs -n1 -I{} ${brightnessctl} --device={} -e set ${brightnessIncrement}+ && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';
            "XF86MonBrightnessDown" = ''
              exec "${ls} /sys/class/backlight/ | xargs -n1 -I{} ${brightnessctl} --device={} -e set ${brightnessIncrement}- && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';

            "XF86AudioRaiseVolume" =
              "exec '${pamixer} -ui ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
            "Shift+XF86AudioRaiseVolume" =
              "exec '${pamixer} -ui ${smallAudioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
            "XF86AudioLowerVolume" =
              "exec '${pamixer} -ud ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
            "Shift+XF86AudioLowerVolume" =
              "exec '${pamixer} -ud ${smallAudioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
            "XF86AudioMute" =
              "exec ${pamixer} --toggle-mute && ( ${pamixer} --get-mute && echo 0 > $SWAYSOCK.wob ) || ${pamixer} --get-volume > $SWAYSOCK.wob";
          };
      };

      extraConfig = ''
        # Auto lock (this does not configure sleeping)
        exec ${pkgs.swayidle}/bin/swayidle -w \
          timeout 300 "swaylock -f" \
          timeout 300 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
          before-sleep "swaylock -f"

        # Cursor
        seat seat0 xcursor_theme Adwaita 24
      '';
    };
  };
}
