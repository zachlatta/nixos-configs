{ pkgs, config, inputs, ... }:

let
  # Define these directly here instead of referencing from config
  hyprland-cursor-name = "Bibata-Modern-Classic-Hyprcursor";
  hyprland-cursor-size = 24;
in
{
  home.packages = with pkgs; [
    # Wayland tools
    mako    # Notification daemon
    wlogout # Logout menu
    wofi    # Launcher (already in systemPackages, but ensures it's available to user)
    wl-clipboard
    slurp
    grim
    brightnessctl # For brightness keybindings
    playerctl     # For media keybindings
    networkmanagerapplet # For nm-applet in autostart
    
    # Fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FontAwesome" ]; })
    font-awesome # Ensure this is explicitly listed for icons
  ];

  # Mako configuration - simplified to avoid errors
  # Using the xdg.configFile approach instead of services.mako
  xdg.configFile."mako/config".text = ''
    font=JetBrainsMono Nerd Font 10
    width=350
    height=100
    padding=10
    border-size=2
    border-radius=5
    default-timeout=5000
    background-color=#282a36dd
    border-color=#bd93f9dd
    text-color=#f8f8f2dd
    # Add more custom mako settings here if needed
  '';

  # Wofi configuration (example style)
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun"; # Show applications by default
      # You can add more wofi settings here
      # Example:
      # width = "30%";
      # lines = 8;
      # term = "${pkgs.kitty}/bin/kitty";
      # allow_images = true;
    };
  };
  xdg.configFile."wofi/style.css".text = ''
    window {
        margin: 0px;
        border: 2px solid #bd93f9; /* Dracula Purple */
        background-color: #282a36; /* Dracula Background */
        border-radius: 5px;
    }

    #input {
        margin: 5px;
        border: none;
        color: #f8f8f2; /* Dracula Foreground */
        background-color: #44475a; /* Dracula Current Line */
        border-radius: 3px;
    }

    #inner-box {
        margin: 5px;
        border: none;
        background-color: #282a36; /* Dracula Background */
    }

    #outer-box {
        margin: 5px;
        border: none;
        background-color: #282a36; /* Dracula Background */
    }

    #scroll {
        margin: 0px;
        border: none;
    }

    #text {
        margin: 5px;
        border: none;
        color: #f8f8f2; /* Dracula Foreground */
    }

    #entry:selected {
        background-color: #44475a; /* Dracula Current Line */
        outline: none;
    }
  '';

  # wlogout configuration (example layout)
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "${pkgs.hyprlock}/bin/hyprlock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        keybind = "p";
      }
    ];
    style = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      background-image: none;
      transition: 0.1s;
    }
    window {
      background-color: rgba(30, 30, 46, 0.8); /* Catppuccin Base */
    }
    button {
      color: #cdd6f4; /* Catppuccin Text */
      background-color: rgba(49, 50, 68, 0.8); /* Catppuccin Surface0 */
      border: 2px solid #313244; /* Catppuccin Surface0 darker for border */
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
      border-radius: 10px;
      margin: 10px;
      padding: 10px;
    }
    button:focus, button:active, button:hover {
      background-color: #45475a; /* Catppuccin Surface1 */
      border: 2px solid #585b70; /* Catppuccin Surface2 */
    }
    #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }
    #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }
    #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }
    #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }
    #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }
    #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
    '';
  };
  xdg.configFile."wlogout/layout".text = builtins.toJSON config.programs.wlogout.layout;
  xdg.configFile."wlogout/style.css".text = config.programs.wlogout.style;

  # Fonts
  fonts.fontconfig.enable = true;
} 