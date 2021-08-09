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
    ] ++ builtins.filter lib.isDerivation (builtins.attrValues plasma5Packages.kdeGear)
      ++ builtins.filter lib.isDerivation (builtins.attrValues plasma5Packages.kdeFrameworks);
  };

  # For the Sway environment, wanted packages go here.
  #
  # This should be considered temporary until the Sway environment is either
  # refactored into a broader config or killed.
  environment.systemPackages =
  let
    chromiumArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  in
  with pkgs; [
    arandr

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

    wayland.windowManager.sway =
    let
      swaymsg = "${pkgs.sway}/bin/swaymsg";

      alacritty = "${pkgs.alacritty}/bin/alacritty";
      dolphin = "${pkgs.dolphin}/bin/dolphin";

      bemenu = "${pkgs.bemenu}/bin/bemenu";
      grim = "${pkgs.grim}/bin/grim";
      gtk-launch = "${pkgs.gnome3.gtk}/bin/gtk-launch";
      j4-dmenu-desktop = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop";
      slurp = "${pkgs.slurp}/bin/slurp";
      wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";

      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      brightnessIncrement = "8";

      pamixer = "${pkgs.pamixer}/bin/pamixer";
      audioIncrement = "10";
      smallAudioIncrement = "5";

      nm-applet = "${pkgs.gnome3.networkmanagerapplet}/bin/nm-applet";
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
    in
    {
      enable = true;

      config = {
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

        terminal = "${alacritty}";

        # j4-dmenu-desktop needs to be wrapped with bash to properly launch
        # programs when fish is set as the default shell
        menu = "SHELL=${sh} ${j4-dmenu-desktop} --dmenu='${bemenu} -i -m all' --term=${alacritty}";

        startup = [
          { command = "${mkfifo} $SWAYSOCK.wob && ${tail} -f $SWAYSOCK.wob | ${wob}"; }
          { command = "${nm-applet} --indicator"; }
        ];

        keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Shift+Return" = "exec '${gtk-launch} chromium-browser.desktop'";
          "${mod}+Shift+f" = "exec ${dolphin}";

          "${mod}+Shift+4" = ''exec OUTPUT=$HOME/Pictures/Screenshots/$(${date} +"%Y-%m-%d %H:%M:%S").png && ${grim} -g "$(${slurp})" "$OUTPUT" && cat "$OUTPUT" | ${wl-copy} --type image/png'';

          "XF86MonBrightnessUp" = ''exec "${ls} /sys/class/backlight/ | xargs -n1 -I{} ${brightnessctl} --device={} -e set ${brightnessIncrement}%+ && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';
          "XF86MonBrightnessDown" = ''exec "${ls} /sys/class/backlight/ | xargs -n1 -I{} ${brightnessctl} --device={} -e set ${brightnessIncrement}%- && ${brightnessctl} -m | ${cut} -f4 -d, | ${head} -n 1 | ${sed} 's/%//' > $SWAYSOCK.wob"'';

          "XF86AudioRaiseVolume" = "exec '${pamixer} -ui ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
          "Shift+XF86AudioRaiseVolume" = "exec '${pamixer} -ui ${smallAudioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
          "XF86AudioLowerVolume" = "exec '${pamixer} -ud ${audioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
          "Shift+XF86AudioLowerVolume" = "exec '${pamixer} -ud ${smallAudioIncrement} && ${pamixer} --get-volume > $SWAYSOCK.wob'";
          "XF86AudioMute" = "exec ${pamixer} --toggle-mute && ( ${pamixer} --get-mute && echo 0 > $SWAYSOCK.wob ) || ${pamixer} --get-volume > $SWAYSOCK.wob";
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
