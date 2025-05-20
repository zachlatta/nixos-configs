{
  wayland.windowManager.hyprland.extraConfig = ''
    # Window rules
    windowrulev2 = float,class:^(org.kde.dolphin)$,title:^(Progress Dialog)$
    windowrulev2 = float,class:^(pavucontrol)$
    windowrulev2 = float,class:^(blueman-manager)$
    windowrulev2 = float,class:^(nm-connection-editor)$
    windowrulev2 = float,class:^(org.kde.ark)$
    windowrulev2 = float,title:^(Open File)$
    windowrulev2 = float,title:^(Save File)$
    windowrulev2 = float,title:^(Choose File)$
    windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
    windowrulev2 = float,class:^(xdg-desktop-portal-kde)$

    # Opacity rules
    windowrulev2 = opacity 0.95,class:^(kitty)$
    windowrulev2 = opacity 0.95,class:^(Alacritty)$

    # No blur for games or performance sensitive apps
    windowrulev2 = noblur,class:^(steam_app.*)$
    windowrulev2 = noblur,class:^(cs2)$

    # Idle inhibit while watching videos
    windowrulev2 = idleinhibit focus,class:^(mpv|.+exe|celluloid|firefox)$
    windowrulev2 = idleinhibit fullscreen,class:^(firefox)$
  '';
} 